require 'base64'
require 'openssl'
require 'digest/sha1'

def prompt(*args)
    print(*args)
    gets
end

puts"Inputs:"
puts
policy_file = File.open(ARGV[0], 'r')
puts "Policy File: #{ARGV[0]}"
policy_content = policy_file.read
puts "Policy Content: #{policy_content}"
secret_key = ARGV[1]
puts

puts "Secret Key: #{ARGV[1]}"
policy = Base64.encode64(policy_content).gsub("\n","")

signature = Base64.encode64(
    OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'),secret_key,policy)).gsub("\n","")
puts
puts

puts "Outputs:"
puts
puts "Policy: #{policy}"
puts

puts "Signature: #{signature}"
puts
