class Log < ApplicationRecord
  belongs_to :employee, optional: true

  validates :command, :in_method, :module_name, presence: true

end
