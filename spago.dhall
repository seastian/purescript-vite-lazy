{ name = "demo-of-purescript-lazy-loading-vite"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "console"
  , "debug"
  , "effect"
  , "halogen"
  , "maybe"
  , "prelude"
  , "remotedata"
  , "transformers"
  , "typelevel-prelude"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
