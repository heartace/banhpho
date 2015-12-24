require 'spec_helper'

describe Banhpho do
  it 'has a version number' do
    expect(Banhpho::VERSION).not_to be nil
  end

  subject(:cli) { cli = Banhpho::CLI.new }

  it "detects pngquant installed" do 
    expect(cli.command? "pngquant").to eq(true)
  end

  it "prints pretty file size" do
    expect(cli.prettyFileSize 1234567).to eq("1.18 MB")
    expect(cli.prettyFileSize 0).to eq("0.0 MB")
  end

  it "can batch compress images" do
    puts "[Task begin]"

    dir = File.dirname __FILE__
    imgDir = File.join(dir, 'test-images')
    imgCopyDir = File.join(dir, 'test-images-copy')
    
    FileUtils.copy_entry(imgDir, imgCopyDir)
    originalSize = computeDirSize imgCopyDir
    cli.compress imgCopyDir
    newSize = computeDirSize imgCopyDir
    FileUtils.remove_dir imgCopyDir

    puts "[Task end]"
    expect(newSize).to be < originalSize
  end

  def computeDirSize dir
    totalSize = 0
    Dir.foreach(dir) do |f|
      fp = File.join(dir, f)
      totalSize += File.size(fp) if File.file?(fp)
    end
    totalSize.to_f
  end
end
