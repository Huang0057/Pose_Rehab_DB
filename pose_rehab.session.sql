-- 註冊時生成隨機 UID
CREATE OR REPLACE FUNCTION gen_random_uid() RETURNS CHAR(8) AS $$
DECLARE
    chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    result TEXT := '';
    i INT;
BEGIN
    FOR i IN 1..8 LOOP
        result := result || substring(chars FROM floor(random() * length(chars) + 1)::int FOR 1);
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--使用者資料
CREATE TABLE users (
    id SERIAL PRIMARY KEY,                  
    username VARCHAR(50) UNIQUE NOT NULL,  
    password VARCHAR(128) NOT NULL,        
    uid CHAR(8) UNIQUE NOT NULL DEFAULT gen_random_uid(),
    coins INT NOT NULL DEFAULT 0
);

--所有玩家的遊玩紀錄
CREATE TABLE game_records (
    id SERIAL PRIMARY KEY,                    
    user_uid VARCHAR(30) NOT NULL,           
    part VARCHAR(50) NOT NULL,               
    play_date DATE NOT NULL,                 
    level_name VARCHAR(100) NOT NULL,        
    start_time TIME NOT NULL,                
    end_time TIME NOT NULL,                 
    duration_time INTERVAL NOT NULL,         
    exercise_count INT NOT NULL,             
    coins_earned INT NOT NULL,               
    FOREIGN KEY (user_uid) REFERENCES users(uid) ON DELETE CASCADE 
);

--所有使用者的簽到記錄
CREATE TABLE user_checkin (
    id SERIAL PRIMARY KEY,                    
    user_uid VARCHAR(30) NOT NULL,           
    checkin_date DATE NOT NULL,              
    signed_in BOOLEAN NOT NULL DEFAULT FALSE, 
    UNIQUE (user_uid, checkin_date),         
    FOREIGN KEY (user_uid) REFERENCES users(uid) ON DELETE CASCADE 
);