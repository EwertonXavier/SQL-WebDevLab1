CREATE if not exists TABLE person (
    id_number int AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100),
    email VARCHAR(100) UNIQUE
)


