require 'yaml'
require_relative 'student'
require_relative 'student_short'
require_relative 'data_list_student_short'

class StudentListYaml
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
    @students = []
    read_from_file
  end

  def read_from_file
    return unless File.exist?(@file_path)

    data = File.read(@file_path, encoding: 'UTF-8')
    return if data.strip.empty?

    student_hashes = YAML.safe_load(data, symbolize_names: true)
    @students = student_hashes.map { |hash| Student.new(**hash) }
  rescue Psych::SyntaxError => e
    puts "YAML parse error: #{e.message}"
    @students = []
  end

  def write_in_file
    student_hashes = @students.map do |student|
      {
        id: student.id,
        last_name: student.last_name,
        first_name: student.first_name,
        patronymic: student.patronymic,
        phone: student.instance_variable_get(:@phone),
        telegram: student.instance_variable_get(:@telegram),
        email: student.instance_variable_get(:@email),
        git: student.git
      }.compact
    end

    File.write(@file_path, student_hashes.to_yaml, encoding: 'UTF-8')
  end

  def get_k_n_student_short(k, n, existing_data_list = nil)
    start_index = (k - 1) * n
    end_index = start_index + n - 1
    slice = @students[start_index..end_index] || []

    short_students_list = slice.map { |student| StudentShort.from_student(student) }

    data_list = existing_data_list || DataListStudentShort.new(short_students_list)
    data_list.elements = short_students_list
    data_list
  end

  def get_student_by_id(id)
    @students.find { |student| student.id == id }
  end

  def add_student(student)
    max_id = @students.map(&:id).compact.max || 0
    student.id = max_id + 1
    @students << student
    write_in_file
    student.id
  end

  def sort_by_LI
    @students.sort_by!(&:last_name_initials)
    write_in_file
  end

  def replace_student_by_id(id, new_student)
    index = @students.find_index { |s| s.id == id }
    return false unless index

    new_student.id = id
    @students[index] = new_student
    write_in_file
    true
  end

  def delete_student_by_id(id)
    @students.reject! { |student| student.id == id }
    write_in_file
  end

  def get_student_short_count
    @students.count
  end
end