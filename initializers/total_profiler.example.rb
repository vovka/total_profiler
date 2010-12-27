TotalProfiler::Config.profile_all = true
TotalProfiler::Config.add_class String, [:split]

TotalProfiler::Base.monkeypatch!
