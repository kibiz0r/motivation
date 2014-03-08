# calculate_path = lambda do
#   parent_path = inherited_opt :path
#   child_path = opt :filename
# 
#   if parent_path
#     File.join parent_path, child_path
#   else
#     child_path
#   end
# end
# 
# Motivation.motive! :path,
#   filename: lambda { name.underscore },
#   extension: lambda { inherited_opt(:extension, '.rb') },
#   path: calculate_path do
#     def path
#       opt :path
#     end
# 
#     def file
#       "#{path}#{require_opt(:extension)}"
#     end
# 
#     def require!
#       require path
#     end
# 
#     def constant
#       require!
#       super
#     end
#   end
