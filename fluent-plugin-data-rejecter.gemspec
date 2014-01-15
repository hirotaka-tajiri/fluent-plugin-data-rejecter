# encoding: utf-8

$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do | gs |
    gs.name          = "fluent-plugin-data-rejecter"
    gs.version       = "1.0.0"
    gs.authors       = ["Hirotaka Tajiri"]
    gs.email         = "ganryu_koziro@excite.co.jp"
    gs.homepage      = "https://github.com/hirotaka-tajiri/fluent-plugin-data-rejecter"
    gs.description   = "Fluent plugin Output filer to reject key pair"
    gs.summary       = "Output filter plugin to reject key pair"
    gs.licenses      = ["MIT"]
    gs.has_rdoc      = false

    gs.files         = `git ls-files`.split("\n")
    gs.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    gs.executables   = `git ls-files -- bin/*`.split("\n").map{| f | File.basename(f)}
    gs.require_paths = ['lib']

    gs.add_dependency 'fluentd', "~> 0.10"
    gs.add_development_dependency "rake", '~>0'
    gs.add_development_dependency "rspec", '~>0'
end
