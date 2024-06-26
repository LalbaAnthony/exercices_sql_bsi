
-- ? Création de la base de données d'un réseau social nommé social_network

-- ? ====================================
-- ?
-- ? Sommaire:
-- ?
-- ? Création des tables de la base de données
-- ? Insertion des données dans les tables
-- ? Vérification des données insérées
-- ? Création des vues
-- ? Création des utilisateurs
-- ? Exemple de requêtes
-- ?
-- ? ====================================

CREATE DATABASE IF NOT EXISTS social_network;
USE social_network;

-- ====================================
-- Création des tables de la base de données
-- ====================================

-- Drop existing tables -- ! Table are dropped in the reverse order of their creation, to avoid foreign key constraint errors
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS friendships;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS statuses;

#------------------------------------------------------------
# Table: statuses
#------------------------------------------------------------

CREATE TABLE statuses (
    status_id INT AUTO_INCREMENT NOT NULL UNIQUE,
    name VARCHAR(63) NOT NULL,
    color VARCHAR(7) NOT NULL UNIQUE DEFAULT '#000000',
    created_at DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT status_PK PRIMARY KEY (status_id)
) ENGINE = InnoDB;

#------------------------------------------------------------
# Table: users
#------------------------------------------------------------

CREATE TABLE users (
    user_id INT AUTO_INCREMENT NOT NULL UNIQUE,
    id_status INT NOT NULL DEFAULT 1,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    token VARCHAR(500),
    password VARCHAR(150) NOT NULL,
    has_validated_email BOOLEAN NOT NULL DEFAULT 0,
    last_login DATETIME,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT user_PK PRIMARY KEY (user_id),
    CONSTRAINT status_FK FOREIGN KEY (id_status) REFERENCES statuses(status_id)
) ENGINE = InnoDB;

#------------------------------------------------------------
# Table: friendships
#------------------------------------------------------------

CREATE TABLE friendships (
    friendship_id INT AUTO_INCREMENT NOT NULL UNIQUE,
    user_id_1 INT NOT NULL,
    user_id_2 INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT friendship_PK PRIMARY KEY (friendship_id),
    CONSTRAINT user1_FK FOREIGN KEY (user_id_1) REFERENCES users(user_id),
    CONSTRAINT user2_FK FOREIGN KEY (user_id_2) REFERENCES users(user_id)
) ENGINE = InnoDB;

#------------------------------------------------------------
# Table: posts
#------------------------------------------------------------

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT NOT NULL UNIQUE,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME DEFAULT NOW(),
    CONSTRAINT post_PK PRIMARY KEY (post_id),
    CONSTRAINT post_user_FK FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE = InnoDB;

#------------------------------------------------------------
# Table: comments
#------------------------------------------------------------

CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT NOT NULL UNIQUE,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT comment_PK PRIMARY KEY (comment_id),
    CONSTRAINT comment_post_FK FOREIGN KEY (post_id) REFERENCES posts(post_id),
    CONSTRAINT comment_user_FK FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE = InnoDB;

#------------------------------------------------------------
# Table: likes
#------------------------------------------------------------

CREATE TABLE likes (
    like_id INT AUTO_INCREMENT NOT NULL UNIQUE,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT like_PK PRIMARY KEY (like_id),
    CONSTRAINT like_post_FK FOREIGN KEY (post_id) REFERENCES posts(post_id),
    CONSTRAINT like_user_FK FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE = InnoDB;

#------------------------------------------------------------
# Table: notifications
#------------------------------------------------------------

CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT NOT NULL UNIQUE,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    seen BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT notification_PK PRIMARY KEY (notification_id),
    CONSTRAINT notification_user_FK FOREIGN KEY (user_id) REFERENCES users(user_id)
);

#------------------------------------------------------------
# Table: messages
#------------------------------------------------------------   

CREATE TABLE messages (
    id INT AUTO_INCREMENT NOT NULL UNIQUE,
    sender_id INT,
    receiver_id INT,
    content TEXT NOT NULL,
    read_at TIMESTAMP NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT message_PK PRIMARY KEY (id),
    CONSTRAINT message_sender_FK FOREIGN KEY (sender_id) REFERENCES users(user_id),
    CONSTRAINT message_receiver_FK FOREIGN KEY (receiver_id) REFERENCES users(user_id)
);

-- ====================================
-- Insertion des données dans les tables
-- ====================================

INSERT INTO statuses (name, color) VALUES 
('Active', '#00FF00'), 
('Invisible', '#CCCCCC'), 
('Inactive', '#FF0000');

INSERT INTO users (id_status, first_name, last_name, email, password) VALUES 
(1, 'John', 'Doe', 'j.doe@gmail.com', 'ilovesgbd'),
(1, 'Ben', 'Smith', 'b.smith@gmail.com', 'ihateespritdequipe');

INSERT INTO friendships (user_id_1, user_id_2, status) VALUES 
(1, 2, 'accepted');

INSERT INTO posts (user_id, content) VALUES 
(1, 'Hello world!'),
(2, 'Hi there!');

INSERT INTO comments (post_id, user_id, content) VALUES 
(1, 2, 'Hello John!'),
(2, 1, 'Hi Ben!');

INSERT INTO likes (post_id, user_id) VALUES 
(1, 2),
(2, 1);

INSERT INTO notifications (user_id, message) VALUES 
(1, 'You have a new friend request from Ben Smith'),
(2, 'John Doe liked your post');

INSERT INTO messages (sender_id, receiver_id, content) VALUES 
(1, 2, 'Hello Ben!'),
(2, 1, 'Hi John!');

-- ====================================
-- Vérification des données insérées
-- ====================================

SELECT * FROM statuses;
SELECT * FROM users;
SELECT * FROM friendships;
SELECT * FROM posts;
SELECT * FROM comments;
SELECT * FROM likes;
SELECT * FROM notifications;
SELECT * FROM messages;

-- ====================================
-- Création des vues
-- ====================================

-- Drop existing views
DROP VIEW IF EXISTS user_statuses;
DROP VIEW IF EXISTS user_posts;
DROP VIEW IF EXISTS post_comments;
DROP VIEW IF EXISTS post_likes_count;

CREATE VIEW user_statuses AS
SELECT u.user_id, u.first_name, u.last_name, s.name AS status
FROM users u
JOIN statuses s ON u.id_status = s.status_id;

CREATE VIEW user_posts AS
SELECT u.user_id, u.first_name, u.last_name, p.post_id, p.content
FROM users u
JOIN posts p ON u.user_id = p.user_id;

CREATE VIEW post_comments AS
SELECT p.post_id, p.content AS post_content, c.comment_id, c.content AS comment_content
FROM posts p
JOIN comments c ON p.post_id = c.post_id;

CREATE VIEW post_likes_count AS
SELECT p.post_id, COUNT(l.like_id) AS likes_count
FROM posts p
LEFT JOIN likes l ON p.post_id = l.post_id

-- ====================================
-- Création des utilisateurs
-- ====================================

-- Create user
DROP USER IF EXISTS 'social-network-user'@'localhost';
CREATE USER 'social-network-user'@'localhost' IDENTIFIED BY 'w11xBg50G2t4YtC1BlbQ';

-- Grant privileges
GRANT SELECT ON `social_network`.statuses TO 'social-network-user'@'localhost';
GRANT INSERT ON `social_network`.statuses TO 'social-network-user'@'localhost';
GRANT UPDATE ON `social_network`.statuses TO 'social-network-user'@'localhost';
GRANT DELETE ON `social_network`.statuses TO 'social-network-user'@'localhost';

GRANT SELECT ON `social_network`.users TO 'social-network-user'@'localhost';
GRANT INSERT ON `social_network`.users TO 'social-network-user'@'localhost';
GRANT UPDATE ON `social_network`.users TO 'social-network-user'@'localhost';
GRANT DELETE ON `social_network`.users TO 'social-network-user'@'localhost';

GRANT SELECT ON `social_network`.friendships TO 'social-network-user'@'localhost';
GRANT INSERT ON `social_network`.friendships TO 'social-network-user'@'localhost';
GRANT UPDATE ON `social_network`.friendships TO 'social-network-user'@'localhost';
GRANT DELETE ON `social_network`.friendships TO 'social-network-user'@'localhost';

GRANT SELECT ON `social_network`.posts TO 'social-network-user'@'localhost';
GRANT INSERT ON `social_network`.posts TO 'social-network-user'@'localhost';
GRANT UPDATE ON `social_network`.posts TO 'social-network-user'@'localhost';
GRANT DELETE ON `social_network`.posts TO 'social-network-user'@'localhost';

GRANT SELECT ON `social_network`.comments TO 'social-network-user'@'localhost';
GRANT INSERT ON `social_network`.comments TO 'social-network-user'@'localhost';
GRANT UPDATE ON `social_network`.comments TO 'social-network-user'@'localhost';
GRANT DELETE ON `social_network`.comments TO 'social-network-user'@'localhost';

GRANT SELECT ON `social_network`.likes TO 'social-network-user'@'localhost';
GRANT INSERT ON `social_network`.likes TO 'social-network-user'@'localhost';
GRANT UPDATE ON `social_network`.likes TO 'social-network-user'@'localhost';
GRANT DELETE ON `social_network`.likes TO 'social-network-user'@'localhost';

GRANT SELECT ON `social_network`.notifications TO 'social-network-user'@'localhost';
GRANT INSERT ON `social_network`.notifications TO 'social-network-user'@'localhost';
GRANT UPDATE ON `social_network`.notifications TO 'social-network-user'@'localhost';
GRANT DELETE ON `social_network`.notifications TO 'social-network-user'@'localhost';

GRANT SELECT ON `social_network`.messages TO 'social-network-user'@'localhost';
GRANT INSERT ON `social_network`.messages TO 'social-network-user'@'localhost';
GRANT UPDATE ON `social_network`.messages TO 'social-network-user'@'localhost';
GRANT DELETE ON `social_network`.messages TO 'social-network-user'@'localhost';

-- ====================================
-- Exemple de requêtes
-- ====================================

-- Get all users with their status
SELECT * FROM user_statuses;

-- Get all posts with their author, who liked them and how many likes they have
SELECT p.post_id, p.content, u.first_name, u.last_name, COUNT(l.like_id) AS likes_count
FROM posts p
JOIN users u ON p.user_id = u.user_id
LEFT JOIN likes l ON p.post_id = l.post_id
GROUP BY p.post_id;

-- Get all comments on posts with their author
SELECT p.post_id, p.content AS post_content, c.comment_id, c.content AS comment_content, u.first_name, u.last_name
FROM posts p
JOIN comments c ON p.post_id = c.post_id
JOIN users u ON c.user_id = u.user_id;

-- Get all unread messages
SELECT * FROM messages WHERE read_at IS NULL;

-- Update the status of a user
UPDATE users
SET id_status = 3
WHERE user_id = 1;