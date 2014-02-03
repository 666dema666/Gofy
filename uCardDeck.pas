unit uCardDeck;

interface

uses
  SysUtils, uCommon, uCardXML;

type
  TItemCard = record
    id: integer;
    data: string;
    exposed: boolean;
  end;

  TLocationCard = record
    id: integer;
    crd_head: PLLData;
    exposed: boolean;
  end;

  TCardDeck = class(TObject) // ����� ����� ����� ����
  private
    fCount: integer; // ���-�� ����
    fCardType: integer; // ��� ����� (�������, ���, ������� � �.�.)
  public
    destructor Destroy; override;
    property Count: integer read fCount;
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
    fCards: array [1..ITEMS_CARD_NUMBER] of TItemCard; // ������ � ������ �����
    function GetCardByID(id: integer): TItemCard;
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

  TLocationCardsDeck = class(TCardDeck) // �����
  private
    fCards: array [1..LOCATION_CARD_NUMBER, 1..3] of TLocationCard; // ������ � ������ �����
    function GetCard(id: integer): TLocationCard; // �������� ����� �� ������ (��� ���� ������� �����). ��� ��-��.
    //function GetLokation: integer;
    //function GetNom: integer;
    //procedure SetLok;
  public
    constructor Create;
    //destructor Destroy; override;
    //property Lokaciya: integer read GetLokation; // ������� ����� (��������)
    function GetCardID(i, n: integer): Integer; overload; // �������� ID ����� �� ����������� ������
    function GetCardData(i, n: integer): PLLData; overload; // �������� ������ ����� �� ����������� ������
    function FindCards(file_path: string): integer; override;
    function DrawCard(n: integer): TLocationCard; // Returns ID of the card on top of the deck
    property cards[id: integer]: TLocationCard read GetCard;
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
  fCardType := crd_type;
  for i := 1 to ITEMS_CARD_NUMBER do
  begin
    fCards[i].id := 0;
    fCards[i].data := '';
    fCards[i].exposed := False;
  end;
end;

function TItemCardDeck.GetCardByID(id: integer): TItemCard;
var
  i: integer;
begin
  for i:= 1 to fCount do
  begin
    if fCards[i].id = id then
      GetCardByID := fCards[i];
  end;
end;

// ��������� ID �����
function TItemCardDeck.GetCardID(i: integer): integer;
begin
  GetCardID := fCards[i].id;
end;

// ��������� ������ ����� (��������� �� ������ �������� ������)
function TItemCardDeck.GetCardData(i: integer): string;
begin
  GetCardData := fCards[i].data;
end;

function TItemCardDeck.DrawCard: Integer;
begin
  DrawCard := fCards[fCount].id;
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
    fCards[i].data := s;
    //Cards^.Cards.Type := CT_UNIQUE_ITEM;
    fCards[i].id := StrToInt(Copy(SR.Name, 1, 4));

    FindRes := FindNext(SR); // ����������� ������ �� �������� ��������
  end;
  FindClose(SR); // ��������� �����
  FindCards := i;
  fCount := i;
end;

// ������� ������
procedure TItemCardDeck.Shuffle();
var
  i, r: integer;
  temp: TItemCard;
begin
  randomize;
  for i := 1 to fCount do
  begin
    temp := fCards[i];
    r := random(Count);
    fCards[i] := fCards[r+1];
    fCards[r+1] := temp;
  end;
end;

///////////////////////////// TLocationCardDeck ////////////////////////////////

// �����������
constructor TLocationCardsDeck.Create;
var
  i, j: Integer;
begin
  fCardType := CT_ENCOUNTER;
  for i := 1 to LOCATION_CARD_NUMBER do
    for j := 1 to 3 do
    begin
      fCards[i, j].id := 0;
      fCards[i, j].crd_head := nil;
      fCards[i, j].exposed := False;
    end;
end;

function TLocationCardsDeck.GetCard(ID: integer): TLocationCard;
var
  i, j: integer;
begin
  for i := 1 to fCount do
    for j := 1 to 3 do
      if fCards[i, j].id = id then
      begin
        Result := fCards[i, j];
        exit;
      end;
end;

{function TLocationCardsDeck.GetCardByID(id: integer): TLocationCard;
var
  i, j: integer;
begin
  for i:= 1 to Count do
    for j := 1 to 3 do
    begin
      if fCards[i, j].id = id then
        GetCardByID := fCards[i, j];
    end;
end;    }

// ��������� ID �����
function TLocationCardsDeck.GetCardID(i, n: integer): integer;
begin
  GetCardID := fCards[i, n].id;
end;

// ��������� ������ �����
function TLocationCardsDeck.GetCardData(i, n: integer): PLLData;
begin
  GetCardData := fCards[i, n].crd_head;
end;


// n - ����� ������� �� �����
function TLocationCardsDeck.DrawCard(n: integer): TLocationCard;
begin
  DrawCard := fCards[fCount div 3, n];
  Shuffle;
end;

// ����� ������ � �������
function TLocationCardsDeck.FindCards(file_path: string): integer;
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
    XML2LL(fCards[i, n].crd_head, file_path);
    //rCards[i, n].Data := s;
    //Cards^.Cards.Type := CT_UNIQUE_ITEM;
    fCards[i, n].id := StrToInt(Copy(SR.Name, 1, 4));

    FindRes := FindNext(SR); // ����������� ������ �� �������� ��������
    //Form1.ComboBox2.Items.Add(IntToStr(Cards^[i].Card_ID));
  end;

  FindClose(SR); // ��������� �����
  FindCards := i;
  fCount := i;
end;

// ������� ������
procedure TLocationCardsDeck.Shuffle();
var
  i, j, r: integer;
  temp: TLocationCard;
begin
  randomize;
  for i := 1 to fCount do
  begin
    r := random(fCount);
    for j := 1 to 3 do
    begin
      temp := fCards[i, j];
      fCards[i, j] := fCards[r+1, j];
      fCards[r+1, j] := temp;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

end.
