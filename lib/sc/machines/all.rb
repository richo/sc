%w[
  top_level
  fn
  fn_body
  expression
].each do |machine|
  require "sc/machines/#{machine}"
end
