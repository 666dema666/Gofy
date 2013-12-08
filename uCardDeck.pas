unit uCardDeck;

interface

uses
  SysUtils;

type
  CCard = record
    ID: integer;
    Data: string;
  end;

  TCardDeck = class(TObject) // ����� ����� ����� ����
  private
    Count: integer; // ���-�� ����
    Card_Type: integer; // ��� ����� (�������, ���, ������� � �.�.)
  public
    destructor Destroy; override;
    //function GetCardID(i: integer): Integer; overload;
    //function GetCardData(i: integer): string; overload;
    //function GetCardByID(id: integer): CCard; overload;
    function FindCards(file_path: string): integer; virtual; abstract;
    function DrawCard(n: integer): Integer; virtual; abstract;
    procedure Shuffle(); virtual; abstract;
    //function Get_Card_By_ID(id: integer): TCard; // ���������� ����� �� �� ID
  end;

  TItemCardDeck = class(TCardDeck)
  private
    Cards: array [1..100] of CCard; // ������ � ������ �����
  public
    constructor Create (crd_type: integer);
    function GetCardID(i: integer): Integer;
    function GetCardData(i: integer): string;
    function GetCardByID(id: integer): CCard;
    function FindCards(file_path: string): integer; override;
    function DrawCard: Integer; //overload;
    procedure Shuffle(); override;
    //destructor Destroy; override;
  end;

  TLocationCardDeck = class(TCardDeck) // �����
  private
    Cards: array [1..100, 1..3] of CCard; // ������ � ������ �����
    //function GetLokation: integer;
    //function GetNom: integer;
    //procedure SetLok;
  public
    constructor Create;
    //destructor Destroy; override;
    function GetCardByID(id: integer): CCard;
    //property Lokaciya: integer read GetLokation; // ������� ����� (��������)
    function GetCardID(i, n: integer): Integer; overload; // �������� ID ����� �� ����������� ������
    function GetCardData(i, n: integer): string; overload; // �������� ������ ����� �� ����������� ������
    function FindCards(file_path: string): integer; override;
    function DrawCard(n: integer): Integer;
    //property Nom: integer;
    procedure Shuffle();
    //function Get_Card_By_ID(id: integer): TCard; // ���������� ����� �� �� ID
  end;

implementation

uses Classes, uCommon;

// ���������� TCardDeck
destructor TCardDeck.Destroy;
begin
  inherited;
end;

/////////////////////////////// TItemCardDeck //////////////////////////////////

// �����������
constructor TItemCardDeck.Create(crd_type: integer);
var
  i: Integer;
begin
  Card_Type := crd_type;
  for i := 1 to 100 do
  begin
    Cards[i].ID := 0;
    Cards[i].Data := '';
  end;
end;

function TItemCardDeck.GetCardByID(id: integer): CCard;
var
  i: integer;
begin
  for i:= 1 to Count do
  begin
    if Cards[i].ID = id then
      GetCardByID := Cards[i];
  end;
end;

// ��������� ID �����
function TItemCardDeck.GetCardID(i: integer): integer;
begin
  GetCardID := Cards[i].ID;
end;

// ��������� ������ �����
function TItemCardDeck.GetCardData(i: integer): string;
begin
  GetCardData := Cards[i].Data;
end;

function TItemCardDeck.DrawCard: Integer;
begin
  DrawCard := cards[Count].ID;
  Shuffle;
end;

// ����� ������ � �������
function TItemCardDeck.FindCards(file_path: string): integer;
var
  F: TextFile;
  SR: TSearchRec; // ��������� ����������
  FindRes: Integer; // ���������� ��� ������ ���������� ������
  s: string[80];
  i: integer;
begin
  // ������� ������� ������ � ������ ������
  FindRes := FindFirst(file_path + '*.txt', faAnyFile, SR);

  i := 0;

  while FindRes = 0 do // ���� �� ������� ����� (��������), �� ��������� ����
  begin
    i := i + 1;
    AssignFile (F, file_path + SR.Name);
    Reset(F);
    readln(F, s);
    CloseFile(F);
    Cards[i].Data := s;
    //Cards^.Cards.Type := CT_UNIQUE_ITEM;
    Cards[i].ID := StrToInt(Copy(SR.Name, 1, 4));

    FindRes := FindNext(SR); // ����������� ������ �� �������� ��������
    //Form1.ComboBox2.Items.Add(IntToStr(Cards^[i].Card_ID));
  end;
  FindClose(SR); // ��������� �����
  FindCards := i;
  Count := i;
end;

// ������� ������
procedure TItemCardDeck.Shuffle();
var
  i, r: integer;
  temp: CCard;
begin
  randomize;
  for i := 1 to Count do
  begin
    temp := Cards[i];
    r := random(Count);
    Cards[i] := Cards[r+1];
    Cards[r+1] := temp;
  end;
end;

///////////////////////////// TLocationCardDeck ////////////////////////////////

// �����������
constructor TLocationCardDeck.Create;
var
  i, j: Integer;
begin
  Card_Type := CT_ENCOUNTER;
  for i := 1 to 100 do
    for j := 1 to 3 do
    begin
      Cards[i, j].ID := 0;
      Cards[i, j].Data := '';
    end;
end;

function TLocationCardDeck.GetCardByID(id: integer): CCard;
var
  i, j: integer;
begin
  for i:= 1 to Count do
    for j := 1 to 3 do
    begin
      if Cards[i, j].ID = id then
        GetCardByID := Cards[i, j];
    end;
end;

// ��������� ID �����
function TLocationCardDeck.GetCardID(i, n: integer): integer;
begin
  GetCardID := Cards[i, n].ID;
end;

// ��������� ������ �����
function TLocationCardDeck.GetCardData(i, n: integer): string;
begin
  GetCardData := Cards[i, n].Data;
end;

function TLocationCardDeck.DrawCard(n: integer): Integer;
begin
  DrawCard := cards[Count div 3, n].ID;
  Shuffle;
end;

// ����� ������ � �������
function TLocationCardDeck.FindCards(file_path: string): integer;
var
  F: TextFile;
  SR: TSearchRec; // ��������� ����������
  FindRes: Integer; // ���������� ��� ������ ���������� ������
  s: string[80];
  i, n: integer;
begin
  // ������� ������� ������ � ������ ������
  FindRes := FindFirst(file_path + '*.txt', faAnyFile, SR);

  i := 0;
  n := 0;

  while FindRes = 0 do // ���� �� ������� ����� (��������), �� ��������� ����
  begin
    if n <> StrToInt(Copy(SR.Name, 2, 1)) then
      i := 0;
    n := StrToInt(Copy(SR.Name, 2, 1));
    i := i + 1;
    AssignFile (F, file_path + SR.Name);
    Reset(F);
    readln(F, s);
    CloseFile(F);
    Cards[i, n].Data := s;
    //Cards^.Cards.Type := CT_UNIQUE_ITEM;
    Cards[i, n].ID := StrToInt(Copy(SR.Name, 1, 4));

    FindRes := FindNext(SR); // ����������� ������ �� �������� ��������
    //Form1.ComboBox2.Items.Add(IntToStr(Cards^[i].Card_ID));
  end;
  FindClose(SR); // ��������� �����
  FindCards := i;
  Count := i;
end;

// ������� ������
procedure TLocationCardDeck.Shuffle();
var
  i, j, r: integer;
  temp: CCard;
begin
  randomize;
  for i := 1 to Count do
    for j := 1 to 3 do
    begin
      temp := Cards[i, j];
      r := random(Count);
      Cards[i, j] := Cards[r+1, j];
      Cards[r+1, j] := temp;
    end;
end;

////////////////////////////////////////////////////////////////////////////////

end.
