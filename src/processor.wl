BeginPackage["JerryI`WolframJSFrontend`ESMProcessor`"];


NPM::usage = "NPM[\"package\"] // Install"

Begin["`Private`"];

root = DirectoryName[$InputFileName]//ParentDirectory;

checkDir[dir_] := Module[{},
  If[!FileExistsQ[FileNameJoin[{dir, "package.json"}]], 
    NotebookPrint["node_modules is missing at "<>dir];
    NotebookPrint["installing..."]
    CopyFile[FileNameJoin[{root, "assets", "package.json"}], FileNameJoin[{dir, "package.json"}]];
    RunProcess[{"npm", "i"}];
  ];
]

NPM /: Install[NPM[name_String]] := Module[{dir = DirectoryName[JerryI`WolframJSFrontend`Notebook`Notebooks[JerryI`WolframJSFrontend`Notebook`$AssociationSocket[Global`client], "path"]]},
  checkDir[dir];
  With[{r = RunProcess[{"npm", "i", name}, ProcessDirectory->dir]},
      If[r["ExitCode"] === 0, 
          r["StandardOutput"]
      ,
          (* fire error event *)
          r["StandardError"]
      ]
  ]
]


ESBuild[input_String] := 
With[{path = (DirectoryName[JerryI`WolframJSFrontend`Notebook`Notebooks[JerryI`WolframJSFrontend`Notebook`$AssociationSocket[Global`client], "path"]])},
    checkDir[path];
    NotebookPrint["building using path: ``", path];
    With[{
        r = RunProcess[{FileNameJoin[{"node_modules", "esbuild", "bin", "esbuild"}], "--bundle", "--format=cjs"}, All, input, ProcessDirectory->path]
    },

        r
    ]
]


ESMQ[str_]       := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.(esm|cjs)$"]]] > 0;


ESMrocessor[expr_String, signature_String, callback_] := Module[{str = StringDrop[expr, StringLength[First[StringSplit[expr, "\n"]]] ], output,r},
  Print["ESMrocessor!"];
  r = ESBuild[str];
  If[r["ExitCode"] === 0, 
    
        callback[
            r["StandardOutput"],
            CreateUUID[], 
            "esm",
            Null
        ];          
      ,
        callback[
            "<span style=\"color:red\">"<>r["StandardError"]<>"</span>",
            CreateUUID[], 
            "html",
            Null
        ];
  ];


];

JerryI`WolframJSFrontend`Notebook`NotebookAddEvaluator[(ESMQ      ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->ESMrocessor       |>), "HighestPriority"];



End[]
EndPackage[]