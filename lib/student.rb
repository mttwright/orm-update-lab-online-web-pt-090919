require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  
  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade)
    
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
  end
  
  def self.create(name, grade)
    new = self.new(name, grade)
    new.save
    new
  end
  
  def self.new_from_db(array)
    new = self.new(array[0], array[1], array[2])
    new
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1;
    SQL
    
    student = DB[:conn].execute(sql, name).first.new_from_db
    
  end


end
