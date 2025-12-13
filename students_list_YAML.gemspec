Gem::Specification.new do |spec|
  spec.name          = "student_list_yaml"
  spec.version       = "0.1.0"
  spec.authors       = ["Ваше Имя"]
  spec.email         = ["ваш.email@example.com"]
  
  spec.summary       = "YAML-based student list management"
  spec.description   = "A gem for managing student lists using YAML format"
  spec.homepage      = "https://github.com/вашusername/student_list_yaml"
  spec.license       = "MIT"
  
  # Указываем файлы явно
  spec.files         = Dir["lib/**/*.rb"] + ["README.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]
  
  # Зависимости для разработки
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end