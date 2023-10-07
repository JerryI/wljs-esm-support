
BeginPackage["JerryI`WolframJSFrontend`ESMBuilder`"];


NPM::usage = "NPM[\"package\"] // Install"

Begin["`Private`"];

(*path["node"] = FileNameJoin[{DirectoryName[$InputFileName]//ParentDirectory, "node", "bin", "node"}]

path["npm"] = FileNameJoin[{DirectoryName[$InputFileName]//ParentDirectory, "node", "bin", "npm"}]
relative["npm"] = "../node/bin/npm"

path["es"] = FileNameJoin[{DirectoryName[$InputFileName]//ParentDirectory, "lib", "node_modules", "bin", "esbuild"}]
relative["es"] = "node_modules/esbuild/bin/esbuild"


lib  = FileNameJoin[{DirectoryName[$InputFileName]//ParentDirectory, "lib"}]
root = FileNameJoin[{DirectoryName[$InputFileName]//ParentDirectory}]

repo = Switch[$OperatingSystem,
  "MacOSX",
    If[$ProcessorType === "x86-64",
      "https://nodejs.org/dist/v18.17.1/node-v18.17.1-darwin-x64.tar.gz"
    ,
      "https://nodejs.org/dist/v18.17.1/node-v18.17.1-darwin-arm64.tar.gz"    
    ]
  ,
  _,
  $Failed
];

NodeJS /: Exists[NodeJS] := FileExistsQ[path["node"]]
NodeJS /: Install[NodeJS] := Module[{newdir},
    Print["wl >> downloading NodeJS from "<>repo<>"..."];
    DeleteDirectory[FileNameJoin[{root, "temp"}], DeleteContents -> True];
    If[repo === $Failed, Print["Unknown system or processor type ;()"]; Return[$Failed, Module]];
    ExtractArchive[repo, FileNameJoin[{root, "temp"}], OverwriteTarget->True];

    newdir = Select[FileNames["*", FileNameJoin[{root, "temp"}]], StringMatchQ[FileBaseName@#, ___~~"node"~~__]&]//First;
    DeleteDirectory[FileNameJoin[{root, "node"}], DeleteContents -> True];
    Print["wl >> copying..."];
    CopyDirectory[newdir, FileNameJoin[{root, "node"}]];
    Print["wl >> installing esbuild..."];
    "esbuild" // NPM // Install // Print;
]; *)

root = DirectoryName[$InputFileName]//ParentDirectory;

checkDir := Module[{dir = Directory[]},
  If[!FileExistsQ["package.json"], 
    Print["node_modules is missing at "<>dir];
    Print["installing..."]
    CopyFile[FileNameJoin[{root, "assets", "package.json"}], "package.json"];
    RunProcess[{"npm", "i"}];
  ];
]

NPM /: Install[NPM[]] := Module[{},
  checkDir;
  With[{r = RunProcess[{"npm", "i"}]},
      If[r["ExitCode"] === 0, 
          r["StandardOutput"]
      ,
          (* fire error event *)
          Style[r["StandardError"], Background->LightRed]
      ]
  ]
]

NPM /: Install[NPM[name_String]] := Module[{},
  checkDir;
  With[{r = RunProcess[{"npm", "i", name}]},
      If[r["ExitCode"] === 0, 
          r["StandardOutput"]
      ,
          (* fire error event *)
          Style[r["StandardError"], Background->LightRed]
      ]
  ]
]

End[]
EndPackage[]
