# encoding: utf-8

$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do | gs |
    gs.name          = "fluent-plugin-data-rejecter"
    gs.version       = "0.0.1"
    gs.authors       = ["Hirotaka Tajiri"]
    gs.email         = "ganryu_koziro@excite.co.jp"
    gs.homepage      = "https://github.com/hirotaka-tajiri/fluent-plugin-data-rejecter"
    gs.description   = "Output filer plugin reject key pair that matches specified conditions"
    gs.summary       = gs.description
    gs.licenses      = ["MIT"]
    gs.has_rdoc      = false

    gs.files         = `git ls-files`.split("\n")
    gs.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    gs.executables   = `git ls-files -- bin/*`.split("\n").map{| f | File.basename(f)}
    gs.require_paths = ['lib']

    gs.add_dependency 'fluentd', "~> 0.10.17"
    gs.add_development_dependency "rake"
    gs.add_development_dependency "rspec"
end
