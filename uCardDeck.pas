unit uCardDeck;

interface

uses
  SysUtils, uCommon;

type
  CCard = record
    ID: integer;
    Data: string;
    exposed: boolean;
  end;

  TCardDeck = class(TObject) // ����� ����� ����� ����
  private
    mCount: integer; // ���-�� ����
    Card_Type: integer; // ��� ����� (�������, ���, ������� � �.�.)
  public
    destructor Destroy; override;
    property Count: integer read mCount;
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
    mCards: array [1..ITEMS_CARD_NUMBER] of CCard; // ������ � ������ �����
    function GetCardByID(id: integer): CCard;
    function GetCardID(i: integer): Integer;
    function GetCardData(i: integer): string;
  public
    constructor Create (crd_type: integer);
    property card[i: integer]: integer read GetCardID;
    function FindCards(file_path: string): integer; override;
    function DrawCard: Integer; //overload;
    procedure Shuffle(); override;
    //destructor Destroy; override;
  end;

  TLocationCardDeck = class(TCardDeck) // �����
  private
    mCards: array [1..LOCATION_CARD_NUMBER, 1..3] of CCard; // ������ � ������ �����
    function GetCard(ID: integer): CCard;
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
    function DrawCard(n: integer): CCard; // Returns ID of the card on top of the deck
    property cards[ID: integer]: CCard read GetCard;
    //property Nom: integer;
    procedure Shuffle();
    //function Get_Card_By_ID(id: integer): TCard; // ���������� ����� �� �� ID
  end;

implementation

uses Classes;

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
  for i := 1 to ITEMS_CARD_NUMBER do
  begin
    mCards[i].ID := 0;
    mCards[i].Data := '';
    mCards[i].exposed := False;
  end;
end;

function TItemCardDeck.GetCardByID(id: integer): CCard;
var
  i: integer;
begin
  for i:= 1 to Count do
  begin
    if mCards[i].ID = id then
      GetCardByID := mCards[i];
  end;
end;

// ��������� ID �����
function TItemCardDeck.GetCardID(i: integer): integer;
begin
  GetCardID := mCards[i].ID;
end;

// ��������� ������ �����
function TItemCardDeck.GetCardData(i: integer): string;
begin
  GetCardData := mCards[i].Data;
end;

function TItemCardDeck.DrawCard: Integer;
begin
  DrawCard := mCards[Count].ID;
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
    mCards[i].Data := s;
    //Cards^.Cards.Type := CT_UNIQUE_ITEM;
    mCards[i].ID := StrToInt(Copy(SR.Name, 1, 4));

    FindRes := FindNext(SR); // ����������� ������ �� �������� ��������
    //Form1.ComboBox2.Items.Add(IntToStr(Cards^[i].Card_ID));
  end;
  FindClose(SR); // ��������� �����
  FindCards := i;
  mCount := i;
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
    temp := mCards[i];
    r := random(Count);
    mCards[i] := mCards[r+1];
    mCards[r+1] := temp;
  end;
end;

///////////////////////////// TLocationCardDeck ////////////////////////////////

// �����������
constructor TLocationCardDeck.Create;
var
  i, j: Integer;
begin
  Card_Type := CT_ENCOUNTER;
  for i := 1 to LOCATION_CARD_NUMBER do
    for j := 1 to 3 do
    begin
      mCards[i, j].ID := 0;
      mCards[i, j].Data := '';
      mCards[i, j].exposed := False;
    end;
end;

function TLocationCardDeck.GetCard(ID: integer): CCard;
var
  i, j: integer;
begin
  for i := 1 to 3 do
    for j := 1 to 7 do
      if mCards[j, i].ID = ID then
      begin
        Result := mCards[j, i];
        exit;
      end;
end;

function TLocationCardDeck.GetCardByID(id: integer): CCard;
var
  i, j: integer;
begin
  for i:= 1 to Count do
    for j := 1 to 3 do
    begin
      if mCards[i, j].ID = id then
        GetCardByID := mCards[i, j];
    end;
end;

// ��������� ID �����
function TLocationCardDeck.GetCardID(i, n: integer): integer;
begin
  GetCardID := mCards[i, n].ID;
end;

// ��������� ������ �����
function TLocationCardDeck.GetCardData(i, n: integer): string;
begin
  GetCardData := mCards[i, n].Data;
end;


// n - ����� ������� �� �����
function TLocationCardDeck.DrawCard(n: integer): CCard;
begin
  DrawCard := mCards[Count div 3, n];
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
  FindRes := FindFirst(file_path + '*.xml', faAnyFile, SR);

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
    mCards[i, n].Data := s;
    //Cards^.Cards.Type := CT_UNIQUE_ITEM;
    mCards[i, n].ID := StrToInt(Copy(SR.Name, 1, 4));

    FindRes := FindNext(SR); // ����������� ������ �� �������� ��������
    //Form1.ComboBox2.Items.Add(IntToStr(Cards^[i].Card_ID));
  end;

  FindClose(SR); // ��������� �����
  FindCards := i;
  mCount := i;
end;

// ������� ������
procedure TLocationCardDeck.Shuffle();
var
  i, j, r: integer;
  temp: CCard;
begin
  randomize;
  for i := 1 to Count do
  begin
    r := random(Count);
    for j := 1 to 3 do
    begin
      temp := mCards[i, j];
      mCards[i, j] := mCards[r+1, j];
      mCards[r+1, j] := temp;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

end.
