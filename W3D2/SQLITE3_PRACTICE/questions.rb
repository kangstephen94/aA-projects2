require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton 
  
  def initialize 
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class ModelBase 
  CLASSES = {
    'Users' => 'users',
    'Questions' => 'questions',
    'QuestionLikes' => 'question_likes',
    'QuestionFollows' => 'question_follows',
    'Replies' => 'replies'
  }
# 
  def self.all
    table = CLASSES[self.to_s]
    QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM 
        #{table}
    SQL
  end

  def self.find_by_id(id)
    table = CLASSES[self.to_s]
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM 
        #{table}
      WHERE 
        id = ?
    SQL
    data.map { |data| self.new(data) }
  end
end 

class Users < ModelBase
  attr_accessor :fname, :lname
  
  def self.find_by_name(fname, lname)
    users = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT 
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?;
    SQL
    users.map { |user| Users.new(user) }
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def authored_questions 
    Questions.find_by_author_id(@id)
  end 
  
  def authored_replies
    Replies.find_by_user_id(@id)
  end 
  
  def followed_questions 
    QuestionFollows.followed_questions_for_user_id(@id)
  end 
  
  def liked_questions 
    QuestionLikes.liked_questions_for_user_id(@id)
  end
  
  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT 
        COUNT(question_likes.user_id) / 
        CAST(COUNT(DISTINCT questions.id) AS FLOAT) 
        AS avg_karma
      FROM
        questions
      LEFT JOIN
        question_likes ON questions.id = question_likes.question_id 
      WHERE
        questions.user_id = ?
      GROUP BY
        questions.user_id;
    SQL
    data.first["avg_karma"]
  end
  
  def save
    if @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        INSERT INTO 
          users (fname, lname)
        VALUES 
          (?, ?);
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, fname, lname, @id)
        UPDATE
          users
        SET
          fname = ?, lname = ?
        WHERE
          id = ?;
      SQL
    end
  end
end


class Questions < ModelBase
  attr_accessor :title, :body, :user_id
  
  def self.find_by_author_id(author_id)
    authors = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT 
        *
      FROM
        questions
      WHERE
        user_id = ?;
    SQL
    authors.map { |author| Questions.new(author) }
  end 
  
  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end
  
  def self.most_liked(n)
    QuestionLikes.most_liked_questions(n)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def author
    Users.find_by_id(@user_id)
  end 
  
  def replies
    Replies.find_by_question_id(@id)
  end
  
  def followers 
    QuestionFollows.followers_for_question_id(@id)
  end 
  
  def likers
    QuestionLikes.likers_for_question_id(@id)
  end
  
  def num_likes
    QuestionLikes.num_likes_for_question_id(@id)
  end 
  
  def save
    if @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, title, body, user_id)
        INSERT INTO 
          questions (title, body, user_id)
        VALUES 
          (?, ?, ?);
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, title, body, user_id)
        UPDATE
          questions
        SET
          title = ?, body = ?, user_id = ?
        WHERE
          id = ?;
      SQL
    end
  end
end

class QuestionFollows < ModelBase
  attr_accessor :user_id, :question_id

  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        *
      FROM
        users
      JOIN
        question_follows ON user_id = users.id
      WHERE
        question_id = ?;
    SQL
    followers.map { |follower| Users.new(follower) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT 
        *
      FROM
        questions
      JOIN
        question_follows ON question_id = questions.id
      WHERE
        question_follows.user_id = ?;
    SQL
    questions.map { |question| Questions.new(question) }
  end
  
  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT 
        *, COUNT(question_follows.user_id) AS Total_Followers
      FROM
        questions
      JOIN
        question_follows ON question_id = questions.id
      GROUP BY 
        questions.id
      ORDER BY 
        Total_Followers DESC 
      LIMIT 
        ?;
    SQL
    questions.map { |question| Questions.new(question) }
  end
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end 

class Replies < ModelBase
  attr_accessor :body, :user_id, :question_id, :parent_id
  
  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        *
      FROM
        replies
      WHERE
        question_id = ?;
    SQL
    replies.map { |reply| Replies.new(reply) }
  end
  
  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT 
        *
      FROM
        replies
      WHERE
        user_id = ?;
    SQL
    replies.map { |reply| Replies.new(reply) }
  end
  
  def self.find_child_by_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM
        replies
      WHERE
        parent_id = ?;
    SQL
    replies.map { |reply| Replies.new(reply) }
  end
  
  def initialize(options)
    @id = options['id']
    @body = options['body']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
  end
  
  def author
    Users.find_by_id(@user_id)
  end
  
  def question
    Questions.find_by_id(@question_id)
  end
  
  def parent_reply
    Replies.find_by_id(@parent_id)
  end
  
  def child_replies 
    Replies.find_child_by_id(@id)
  end
  
  def save
    if @id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, body, user_id, question_id, parent_id)
        INSERT INTO 
          replies (body, user_id, question_id, parent_id)
        VALUES 
          (?, ?, ?, ?);
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, body, user_id, question_id, parent_id)
        UPDATE
          replies
        SET
          body = ?, user_id = ?, question_id = ?, parent_id = ?
        WHERE
          id = ?;
      SQL
    end
  end
end 

class QuestionLikes < ModelBase
  attr_accessor :user_id, :question_id
  
  def self.likers_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        *
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?;
    SQL
    likers.map { |liker| Users.new(liker) }
  end
  
  def self.num_likes_for_question_id(question_id)
    # likers_for_question_id(question_id).count 
    
    likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT 
        COUNT(user_id)
      FROM
        question_likes
      WHERE
        question_id = ?
      GROUP BY
        question_id;
    SQL
    likes.map { |like| Users.new(like) }
  end
  
  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT 
        *
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL
    questions.map { |question| Questions.new(question) }
  end
  
  def self.most_liked_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT 
        body, COUNT(question_likes.user_id) AS most_likes
      FROM
        questions 
      JOIN 
        question_likes ON questions.id = question_likes.question_id 
      GROUP BY question_likes.question_id
      ORDER BY most_likes DESC
      LIMIT 
         ?;
    SQL
    questions.map { |question| Questions.new(question) }
  end
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end 

