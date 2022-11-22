module Version
  class Version
    @@major = 3
    @@minor = 1
    @@patch = 0
    @@text = "#{@@major}.#{@@minor}.#{@@patch}"
    @@copyright = "&copy; 2015-2022 Matthew Petricone"
    @@version_text = " | Version "
    @@contact_email = "matt@solidstate.solutions"
    @@contact_name = "Matthew Petricone"
    @@build_note = "Ceti Alpha 5"

    def self.version
      return @@text.html_safe
    end

    def self.copyright_version
      return (@@copyright + @@version_text + self.version).html_safe
    end

    def self.copyright
      return @@copyright.html_safe
    end

    def self.contact_email
      return @@contact_email.html_safe
    end

    def self.contact_name
      return @@contact_name.html_safe
    end

    def self.build_note
      return @@build_note.html_safe
    end
  end
end
