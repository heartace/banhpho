require "thor"
require 'colorize'

module Banhpho
	class CLI < Thor

		desc "compress DIR", "compress all png files in DIR"
		def compress(dir)
			@count = 0
			@originalSize = 0
			@newSize = 0

			abort("Error: command pngquant is not found, please download it from https://pngquant.org/ and put it in your global path") unless command?("pngquant")
			abort("Error: argument '#{dir}' is not a valid directory") unless File.directory?(dir)

			compressInDir(dir)
			puts("=" * 20)
			msg = "#{@count} files compressed!"
			color = @count == 0 ? :red : :blue
			puts msg.colorize(color)
			if @originalSize > 0 then
				puts("original size: #{prettyFileSize(@originalSize)}, after compression: #{prettyFileSize(@newSize)}, compression ratio: #{(1 - @newSize.to_f / @originalSize).round(4) * 100}%".colorize(:blue))
			end
		end

		desc "version", "print the version of current release"
		map ['-v', 'v', '--version'] => :version
		def version()
			puts VERSION
		end

		no_commands do
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
						@originalSize += File.size(path)
						exePath = path.gsub(/ /, "\\ ")
						puts("  compressing file: #{path}")
						%x(pngquant --force --ext .png --skip-if-larger -- #{exePath})
						@count += 1
						@newSize += File.size(path)
					end
				end
			end

			def prettyFileSize(size)
				"#{(size.to_f / 2**20).round(2)} MB"
			end

			def command?(command)
				system("which #{ command} > /dev/null 2>&1")
			end
		end
	end
end
