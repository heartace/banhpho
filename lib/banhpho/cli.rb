require "thor"
require 'colorize'
require 'progress_bar'

module Banhpho
	class CLI < Thor

		desc "compress DIR", "compress all png files in DIR"
		def compress(dir)
			abort("Error: command pngquant is not found, please download it from https://pngquant.org/ and put it in your global path") unless command?("pngquant")
			abort("Error: argument '#{dir}' is not a valid directory") unless File.directory?(dir)

			originalSize = 0
			newSize = 0

			imgs = []
			compressInDir(dir) do |f|
				imgs << f
				originalSize += File.size(f)
			end
			bar = ProgressBar.new(imgs.size)
			imgs.each do |f|
				%x(pngquant --force --ext .png --skip-if-larger -- #{f})
				bar.increment!
				newSize += File.size(f)
			end

			count = imgs.size
			color = count == 0 ? :red : :green
			puts ("=" * 20).colorize(color)
			msg = "#{count} files compressed!"
			puts msg.colorize(color)
			if originalSize > 0 then
				puts("original size: #{prettyFileSize(originalSize)}, after compression: #{prettyFileSize(newSize)}, compression ratio: #{(1 - newSize.to_f / originalSize).round(4) * 100}%".colorize(color))
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
						compressInDir(path)
						next
					end
					ext = File.extname(path).downcase
					if ext == ".png" then
						fixedPath = path.gsub(/ /, "\\ ")
						yield fixedPath 
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
