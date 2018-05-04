DROP TABLE users;
DROP TABLE questions;
DROP TABLE question_follows;
DROP TABLE question_likes;
DROP TABLE replies;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Qi', 'Huang'),
  ('Stephen', 'Kang'),
  ('Aaron', 'Johnson');
  
INSERT INTO 
  questions (title, body, user_id)
VALUES
  ('A01', 'How many questions?', 1),
  ('A02', 'What is the difficulty?', 2),
  ('A03', 'How long is the test?', 3),
  ('A04', 'Is this an extra question?', 1);
  
  
INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (2, 1),
  (2, 2),
  (2, 3),
  (3, 3),
  (3, 3),
  (3, 3);
    
INSERT INTO
  replies (body, user_id, question_id, parent_id)
VALUES 
  ('6', 2, 1, Null),
  ('5', 3, 1, 1),
  ('Hard', 1, 2, Null),
  ('No Idea', 3, 2, 3),
  ('No Idea', 1, 3, Null),
  ('Long', 2, 3, 5);

INSERT INTO
  question_likes (user_id, question_id)
VALUES 
  (1, 1),
  (1, 2),
  (1, 3),
  (2, 1),
  (2, 2),
  (2, 3),
  (3, 1),
  (3, 2),
  (3, 3);
  
    

  
  

    
  
  