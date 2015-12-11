require "banhpho/version"

module Banhpho
	$count = 0
	$originalSize = 0
	$newSize = 0

	def compressInDir (dir)
		Dir.foreach(dir) do |item|
			next if item == "." or item == ".."
			path = File.join(dir, item)
			if File.directory?(path)
				puts("checking directory: #{path}")
				compressInDir(path)
				next
			end
			ext = File.extname(path).downcase
			if ext == ".png" then
				$originalSize += File.size(path)
				puts("  compressing file: #{path}")
				%x(pngquant --force --ext .png --skip-if-larger -- #{path})
				$count += 1
				$newSize += File.size(path)
			end
		end
	end

	def prettyFileSize(size)
		"#{(size.to_f / 2**20).round(2)} MB"
	end

	def command?(command)
		system("which #{ command} > /dev/null 2>&1")
	end

	if ARGV.length == 1 then
		abort("Error: command pngquant is not found, please download it from https://pngquant.org/ and put it in your global path") unless command?("pngquant")
		dir = ARGV[0]
		abort("Error: argument '#{dir}' is not a valid directory") unless File.directory?(dir)

		compressInDir(dir)
		puts("==========")
		puts("#{$count} files compressed!")
		if $originalSize > 0 then
			puts("original size: #{prettyFileSize($originalSize)}, after compression: #{prettyFileSize($newSize)}, compression ratio: #{(1 - $newSize.to_f / $originalSize).round(4) * 100}%")
		end
	elsif ARGV.length == 0 then
	  abort("usage:    PATH_TO/slimpng DIRECTORY_PATH")
	else
		abort("Error: arguments length incorrect")
	end
end
