unit uCardDeck;

interface

uses
  SysUtils;

type
  CCard = record
    ID: integer;
    Data: string;
  end;

  TCardDeck = class(TObject) // �����
  private
    Count: integer;
    Cards: array [1..100, 1..3] of CCard; // ������ � ������ �����
    Card_Type: integer; // ��� ����� (����, ���, ������� � �.�.)
                       // "�����", ��� ������ � ������ ����� ������� ProcessCard
    function GetLokation: integer;
    function GetNom: integer;
    //procedure SetLok;
  public
    constructor Create;
    destructor Destroy; override;
    function GetCardByID(id: integer): CCard;
    property Lokaciya: integer read GetLokation; // ������� ����� (��������)
    function Get_Card_ID(id, n: integer): Integer;
    function Get_Card_Data(id, n: integer): string;
    function Find_Cards(file_path: string): integer;
    function DrawCard(n: integer): Integer;
    //property Nom: integer;
    procedure Dejstvie_karti; // ���������� ����������� �������� �����
    procedure Shuffle();
    //function Get_Card_By_ID(id: integer): TCard; // ���������� ����� �� �� ID
  end;

const
  // ��������� ����� ����
  CT_DEJSTVIE = 6;
  CT_KONTAKT = 7;
  CT_MYTHOS = 8; // ���
  CT_HEADLINE = 9; // ����
  CT_COMMON_ITEM = 1; // ������� �������� (������ ����� � ID)
  CT_UNIQUE_ITEM = 2; // ���������� �������� (������ ����� � ID)
  CT_ENCOUNTER = 3; // ������� (������ ����� � ID)
  // ��������� ��������
  AT_SPEC = 2;
  AT_WATCH_BUY = 3;

implementation

uses Classes;

// �����������
constructor TCardDeck.Create;
var
  i, j: Integer;
begin
  for i := 1 to 100 do
    for j := 1 to 3 do
    begin
      Cards[i, j].ID := 0;
      Cards[i, j].Data := '';
    end;
end;

// ���������� TCard
destructor TCardDeck.Destroy;
begin
  inherited;
end;

function TCardDeck.GetCardByID(id: integer): CCard;
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

function TCardDeck.GetLokation: integer;
begin
  GetLokation := 1;//StrToInt(Copy(Card_Data, 0, 2));
end;

function TCardDeck.GetNom: integer;
begin
  GetNom := 1;//StrToInt(Copy(Card_Data, 2, 2));
end;

// ��������� ID �����
function TCardDeck.Get_Card_ID(id, n: integer): integer;
begin
  Get_Card_ID := Cards[id, n].ID;
end;

// ��������� ������ �����
function TCardDeck.Get_Card_Data(id, n: integer): string;
begin
  Get_Card_Data := Cards[id, n].Data;
end;

function TCardDeck.DrawCard(n: integer): Integer;
begin
  DrawCard := cards[Count div 3, n].ID;
  Shuffle;
end;

// ����� ������ � �������
function TCardDeck.Find_Cards(file_path: string): integer;
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
  Find_Cards := i;
  Count := i;
end;

// ���������� �������� �����
Procedure TCardDeck.Dejstvie_karti;
var
  Action_Type: integer;
begin
  // � ����������� �� ����
  case Card_Type of
    CT_DEJSTVIE:;
    CT_KONTAKT:
    begin
      Action_Type := 1; //StrToInt(Cards[4].Data[4]);
      case Action_Type of
        AT_WATCH_BUY:
        begin{
          Form1.Label14.Caption := Copy(Card_Data, 1, 3);
          Form1.Label4.Caption := '�����. � �����.';
          case StrToInt(Card_Data[5]) of
            1: Form1.Label5.Caption := '������� ����';
            2: Form1.Label5.Caption := '���������� ����';
            3: Form1.Label5.Caption := '����������';
            4: Form1.Label5.Caption := '�����';
            5: Form1.Label5.Caption := '�������';
          end;
          Form1.Label7.Caption := Card_Data[6];
          Form1.Label9.Caption := Card_Data[7];
          Form1.Label11.Caption := Card_Data[8];}
        end;
        AT_SPEC:
        begin
          {Form1.Label4.Caption := '����. �����';
          case StrToInt(Card_Data[9]) of
            1: Form1.Label5.Caption := '�������';
            2: Form1.Label5.Caption := '�����. ����';
            3: Form1.Label5.Caption := '�����';
            4: Form1.Label5.Caption := '���. ������';
            5: Form1.Label5.Caption := '�����';
            6: Form1.Label5.Caption := '����';
          end;                                   }

        end;
      end;
    end;
    CT_MYTHOS:;
    CT_HEADLINE:;
    CT_COMMON_ITEM: begin
   {  Form1.lblPrm1.Caption := Form1.ComboBox1.Text;
      Form1.lblPrm2.Caption := Copy(Form1.ComboBox1.Text, 2, 2);
      Form1.lblPrm3.Caption := Cards[1].Data[1];
      Form1.lblPrm4.Caption := Cards[1].Data[4];
      //lblPrm5.Caption := Card_Data[6];
      case StrToInt(Cards[1].Data[6]) of
        0: Form1.lblPrm5.Caption := '����';
        1: Form1.lblPrm5.Caption := '�����';
        2: Form1.lblPrm5.Caption := '���� ��������';
        3: Form1.lblPrm5.Caption := '�����';
        4: Form1.lblPrm5.Caption := '�������� �����';
      end;
      Form1.lblPrm6.Caption := Cards[1].Data[7];
      Form1.lblCardData.Caption := Cards[1].Data;       }
    end; // CT_COMMON_ITEM

    CT_UNIQUE_ITEM: begin
    {  Form1.lblPrm21.Caption := Form1.ComboBox2.Text;
      Form1.lblPrm22.Caption := Copy(Form1.ComboBox2.Text, 2, 2);
      Form1.lblPrm23.Caption := Cards[1].Data[1];
      Form1.lblPrm24.Caption := Cards[1].Data[4];
      //lblPrm5.Caption := Card_Data[6];
      case StrToInt(Cards[1].Data[6]) of
        0: Form1.lblPrm25.Caption := '����';
        1: Form1.lblPrm25.Caption := '�����';
        2: Form1.lblPrm25.Caption := '���� ��������';
        3: Form1.lblPrm25.Caption := '�����';
        4: Form1.lblPrm25.Caption := '�������� �����';
      end;
      Form1.lblPrm26.Caption := Cards[1].Data[7];
      Form1.lblCardData2.Caption := Cards[1].Data;      }
    end; // CT_COMMON_ITEM

    CT_ENCOUNTER: begin
    {  Form1.lblPrm21.Caption := Form1.ComboBox2.Text;
      Form1.lblPrm22.Caption := Copy(Form1.ComboBox2.Text, 2, 2);
      Form1.lblPrm23.Caption := Cards[1].Data[1];
      Form1.lblPrm24.Caption := Cards[1].Data[4];
      //lblPrm5.Caption := Cards[1].Data[6];
      case StrToInt(Cards[1].Data[6]) of
        0: Form1.lblPrm25.Caption := '����';
        1: Form1.lblPrm25.Caption := '�����';
        2: Form1.lblPrm25.Caption := '���� ��������';
        3: Form1.lblPrm25.Caption := '�����';
        4: Form1.lblPrm25.Caption := '�������� �����';
      end;
      Form1.lblPrm26.Caption := Cards[1].Data[7];
      Form1.lblCardData2.Caption := Cards[1].Data;     }
    end; // CT_COMMON_ITEM
  end;
end;

// ������� ������
procedure TCardDeck.Shuffle();
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

end.
 