program Make;
{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  StrUtils,
  FileUtil,
  Process;

const
  Source = 'src';

var
  Output, Line, LPI: ansistring;
  Projects: TStringList;
  Project: String;

begin
  if FileExists('.gitmodules') then
    if RunCommand('git', ['submodule', 'update', '--init', '--recursive',
      '--force', '--remote'], Output) then
      Writeln(Output);
  Projects := FindAllFiles(Source, '*.lpi', True);
  try
    for Project in Projects do
      if RunCommand('lazbuild', ['--build-all', '--recursive',
        '--no-write-project', Project], Output) then
      begin
        for Line in SplitString(Output, #10) do
        begin
          if Pos('Linking', Line) <> 0 then
            writeln(Line);
        end;
      end;
  finally
    Projects.Free;
  end;
end.
