unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Jpeg, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    Button2: TButton;
    Button3: TButton;
    GroupBox2: TGroupBox;
    lblPlrStamina: TLabel;
    Label1: TLabel;
    lblPlrSanity: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblPlrFocus: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    Label7: TLabel;
    imDie1: TImage;
    lblRolls: TLabel;
    imDie2: TImage;
    imDie3: TImage;
    imDie4: TImage;
    imDie5: TImage;
    imDie6: TImage;
    imDie7: TImage;
    btnRollADie: TButton;
    Edit1: TEdit;
    lblNRolls: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Label3: TLabel;
    lblPrm2: TLabel;
    lblPrm3: TLabel;
    Label6: TLabel;
    lblPrm4: TLabel;
    Label8: TLabel;
    lblPrm5: TLabel;
    Label10: TLabel;
    lblPrm6: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    lblPrm1: TLabel;
    lblCardData: TLabel;
    ComboBox1: TComboBox;
    Button4: TButton;
    Button5: TButton;
    GroupBox3: TGroupBox;
    Image2: TImage;
    Label9: TLabel;
    lblPrm22: TLabel;
    lblPrm23: TLabel;
    Label15: TLabel;
    lblPrm24: TLabel;
    Label17: TLabel;
    lblPrm25: TLabel;
    Label19: TLabel;
    lblPrm26: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    lblPrm21: TLabel;
    lblCardData2: TLabel;
    ComboBox2: TComboBox;
    Button6: TButton;
    Button7: TButton;
    cbLocation: TComboBox;
    Label11: TLabel;
    lblSkillCheck: TLabel;
    lblNSuccesses: TLabel;
    lblSkill: TLabel;
    lblNumSuccesses: TLabel;
    Button8: TButton;
    Button9: TButton;
    lblLocIDCaption: TLabel;
    lblLocID: TLabel;
    lblLocCardDataCaption: TLabel;
    lblLocCardData: TLabel;
    imEncounter: TImage;
    lblStatSpeed: TLabel;
    Label16: TLabel;
    lblStatSneak: TLabel;
    Label18: TLabel;
    lblStatFight: TLabel;
    Label23: TLabel;
    lblStatWill: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    lblStatLore: TLabel;
    Label28: TLabel;
    lblStatLuck: TLabel;
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRollADieClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure cbLocationChange(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  // �����
  ST_SPEED = 1;
  ST_SNEAK = 2;
  ST_FIGHT = 3;
  ST_WILL = 4;
  ST_LORE = 5;
  ST_LUCK = 6;
  // ��������� ���
  PH_PEREDISHKA = 1;
  PH_DVIJENIE = 2;
  PH_KONTAKTI_V_ARKHEME = 3;
  PH_KONTAKTI_V_INIH_MIRAH = 4;
  PH_MIF = 5;
  // ��������� ����� ����
  CT_DEJSTVIE = 6;
  CT_KONTAKT = 7;
  CT_MYTHOS = 8; // ���
  CT_HEADLINE = 9; // ����
  CT_COMMON_ITEM = 1; // ������� �������� (������ ����� � ID)
  CT_UNIQUE_ITEM = 2; // ���������� �������� (������ ����� � ID)
  CT_LOCATION = 3; // ���������� �������� (������ ����� � ID)
  // ��������� ��������
  AT_SPEC = 2;
  AT_WATCH_BUY = 3;
  TLocationName: array [1..16] of string = ('607 Water St.', '7th House on the Left',
        'Administration Building', 'Arkham Asylum',
        'Artists'' Colony', 'Bank of Arkham', 'Bishop''s Brook Bridge', 'Black Cave',
        'Cold Spring Glen', 'Congregational Hospital', 'Curiositie Shoppe',
        'Darke''s Carnival', 'Devil Reef', 'Devil''s Hopyard', 'Dunwich Village',
        'Esoteric Order of Dragon');


type

  TCard = class(TObject) // �����
  private
    Card_ID: integer;
    Card_Type: integer; // ��� ����� (����, ���, ������� � �.�.)
    Card_Data: string; // ������ � ������� � ����� � ����������� �� ����
                       // "�����", ��� ������ � ������ ����� ������� ProcessCard
    function GetLokation: integer;
    function GetNom: integer;
    //procedure SetLok;
  public
    constructor Create;
    destructor Destroy; override;
    function Get_Card_ID: integer;
    property Lokaciya: integer read GetLokation; // ������� ����� (��������)
    function Get_Card_Data: string;

    //property Nom: integer;
    procedure Dejstvie_karti; // ���������� ����������� �������� �����
    procedure Shuffle();
    //function Get_Card_By_ID(id: integer): TCard; // ���������� ����� �� �� ID
  end;

  TPlayer = class
  private

    Location: integer;
    Cards: array [1..100] of integer; // �������� ������
    Items_Count: integer; // ���-�� ��������� � ������
    bFirst_Player: boolean; // ���� ������� ������
  public
    Sanity: integer;
    Stamina: integer;
    Focus: integer;
    Stats: array [1..6] of integer; // ����� ������ (1 - ��������, 2 - ����������)
    constructor Create(var InitStats: array of integer; First_Player: boolean);
    destructor Destroy; override;
    procedure Draw_Card(Card_ID: integer);
    function Get_Items_Count(): integer;
    function Get_Sanity(): integer;
    function Get_Stamina(): integer;
    function Get_Focus: integer;
    function Get_Stat(n: integer): integer;
    function Get_Item(indx: integer): integer;
    function RollADice(Sender: TPlayer; stat: integer): integer;
    //property Speed: integer read Stats[1] write Stats[1];
  end;
  TArrayOfCard = array [1..100] of TCard;
  PArrayOfCard = ^TArrayOfCard;

var
  Form1: TForm1;
  gCurrent_phase: integer;
  Cards0, Cards1: array [1..100] of TCard; // ������� ����
  Common_Items_Deck: array [1..100] of TCard;
  Unique_Items_Deck: array [1..100] of TCard;
  Locations_Deck: array [1..100] of TCard;
  Common_Items_Count: integer = 0;
  Unique_Items_Count: integer = 0;
  Locations_Count: integer = 0;
  Cards_Count: integer = 0;
  gPlayer: TPlayer;
  function Load_Cards(Card_Type: integer; Cards: PArrayOfCard): integer;

implementation

{$R *.dfm}

function Get_Card_By_ID(Cards: PArrayOfCard; id: integer): TCard;
var
  i: integer;
begin
  for i:= 1 to 100 do
    if Cards^[i].Card_ID = id then
      Get_Card_By_ID := Cards^[i];
end;

// ����������� ������
constructor TPlayer.Create(var InitStats: array of integer; First_Player: boolean);
var
  i: integer;
begin
  Stamina := 0;
  Sanity := 0;
  Focus := 0;
  Stats[1] := InitStats[0];
  Stats[2] := InitStats[1];
  Stats[3] := InitStats[2];
  Stats[4] := InitStats[3];
  Stats[5] := InitStats[4];
  Stats[6] := InitStats[5];

  //SetLength(Cards, 0);
  for i := 1 to 100 do
    Cards[i] := 0;
  bFirst_Player := False;
  Items_Count := 0;
end;

// ���������� ������� TPlayer
destructor TPlayer.Destroy;
begin
  inherited;
end;

// �������: ������ ����� �� ������
procedure TPlayer.Draw_Card(Card_ID: integer);
begin
  Items_Count := Items_Count + 1;
  //SetLength(Cards, Items_Count);
  Cards[Items_Count] := Card_ID;
end;

// �������: ��������� ���-�� ��������� � ������
function TPlayer.Get_Items_Count;
begin
  Get_Items_Count := Items_Count;
end;

// �������: ��������� �������� "����" ������
function TPlayer.Get_Stamina;
begin
  Get_Stamina := Stamina;
end;

// �������: ��������� �������� "������" ������
function TPlayer.Get_Sanity;
begin
  Get_Sanity := Sanity;
end;

// �������: ��������� �������� "�����������" ������
function TPlayer.Get_Focus;
begin
  Get_Focus := Focus;
end;

// �������: ��������� ������� 1 �� 6 ������
function TPlayer.Get_Stat(n: integer): integer;
begin
  Get_Stat := Stats[n];
end;

// �������: ��������� �������� �� �������.
// ������� �������� �� ������, � �� ��������
function TPlayer.Get_Item(indx: integer): integer;
begin
  Get_Item := Cards[indx];
end;

// ������ ������ (���������� ����� �������, 0 - ������)
function TPlayer.RollADice(Sender: TPlayer; stat: integer): integer;
var
  r, i: integer;
  Roll_results: array [1..12] of integer;
  Successes: integer;
begin
  randomize;
  Successes := 0;
  //RollADice := random(6)+1;
    //pl := TPlayer.Create(False);
  if Stats[stat] > 0 then
  begin
    for i:=1 to Stats[stat] do
    begin
      Roll_results[i]:=random(6)+1;
      case Roll_results[i] of
      1: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\1.jpg');
      2: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\2.jpg');
      3: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\3.jpg');
      4: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\4.jpg');
      5: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\5.jpg');
      6: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\6.jpg');
      end;
      
      if Roll_results[i]>=5 then
      begin
        Successes := Successes + 1;
        //broskub.usp:=true;
        //broskub.kolusp:=broskub.kolusp+1;
        //if broskub.resbroskub[i]=6 then broskub.kolusp6:=broskub.kolusp6+1;
      end;
    end;
  end;
  RollADice := Successes;
end;

function TCard.Get_Card_Data: string;
begin
  Get_Card_Data := Card_Data;
end;

// �������� ������ � ����� �� �����
function Load_Cards(Card_Type: integer; Cards: PArrayOfCard): integer;
var
  F: TextFile;
  File_Name: string;
  s: string[80];
  //temp: TCard;
  SR: TSearchRec; // ��������� ����������
  FindRes: Integer; // ���������� ��� ������ ���������� ������
  i: integer;
begin
  case Card_Type of
    CT_KONTAKT: begin
      // ������� ������� ������ � ������ ������
      FindRes := FindFirst('..\\Gofy\\CardsData\\*.txt', faAnyFile, SR);

      i := 0;

      while FindRes = 0 do // ���� �� ������� ����� (��������), �� ��������� ����
      begin
        i := i + 1;
        AssignFile (F, '..\\Gofy\\CardsData\\' + SR.Name);
        Reset(F);
        readln(F, s);
        CloseFile(F);
        Cards^[i].Card_Data := s;
        Cards^[i].Card_Type := CT_KONTAKT;
        Cards^[i].Card_ID := StrToInt(Copy(SR.Name, 1, 4));
        FindRes := FindNext(SR); // ����������� ������ �� �������� ��������

      end;
      FindClose(SR); // ��������� �����
      Load_Cards := i;
    end;

    CT_COMMON_ITEM: begin
      // ������� ������� ������ � ������ ������
      FindRes := FindFirst('..\\Gofy\\CardsData\\CommonItems\\*.txt', faAnyFile, SR);

      i := 0;

      Form1.ComboBox1.Clear;
      Form1.ComboBox1.Text := 'Choose a card';

      while FindRes = 0 do // ���� �� ������� ����� (��������), �� ��������� ����
      begin
        i := i + 1;
        AssignFile (F, '..\\Gofy\\CardsData\\CommonItems\\' + SR.Name);
        Reset(F);
        readln(F, s);
        CloseFile(F);
        Cards^[i].Card_Data := s;
        Cards^[i].Card_Type := CT_COMMON_ITEM;
        Cards^[i].Card_ID := StrToInt(Copy(SR.Name, 1, 4));
        FindRes := FindNext(SR); // ����������� ������ �� �������� ��������
        Form1.ComboBox1.Items.Add(IntToStr(Cards^[i].Card_ID));
      end;
      FindClose(SR); // ��������� �����
      Load_Cards := i;
    end; // CT_COMMON_ITEM

    CT_UNIQUE_ITEM: begin
      // ������� ������� ������ � ������ ������
      FindRes := FindFirst('..\\Gofy\\CardsData\\UniqueItems\\*.txt', faAnyFile, SR);

      i := 0;

      Form1.ComboBox2.Clear;
      Form1.ComboBox2.Text := 'Choose a card';

      while FindRes = 0 do // ���� �� ������� ����� (��������), �� ��������� ����
      begin
        i := i + 1;
        AssignFile (F, '..\\Gofy\\CardsData\\UniqueItems\\' + SR.Name);
        Reset(F);
        readln(F, s);
        CloseFile(F);
        Cards^[i].Card_Data := s;
        Cards^[i].Card_Type := CT_UNIQUE_ITEM;
        Cards^[i].Card_ID := StrToInt(Copy(SR.Name, 1, 4));
        FindRes := FindNext(SR); // ����������� ������ �� �������� ��������
        Form1.ComboBox2.Items.Add(IntToStr(Cards^[i].Card_ID));
      end;
      FindClose(SR); // ��������� �����
      Load_Cards := i;
    end; // CT_UNIQUE_ITEM

    CT_LOCATION: begin
      // ������� ������� ������ � ������ ������
      FindRes := FindFirst('..\\Gofy\\CardsData\\Locations\\*.txt', faAnyFile, SR);

      i := 0;

      Form1.cbLocation.Clear;
      Form1.cbLocation.Text := 'Choose a card';

      while FindRes = 0 do // ���� �� ������� ����� (��������), �� ��������� ����
      begin
        i := i + 1;
        AssignFile (F, '..\\Gofy\\CardsData\\Locations\\' + SR.Name);
        Reset(F);
        readln(F, s);
        CloseFile(F);
        Cards^[i].Card_Data := s;
        Cards^[i].Card_Type := CT_COMMON_ITEM;
        Cards^[i].Card_ID := StrToInt(Copy(SR.Name, 1, 4));
        FindRes := FindNext(SR); // ����������� ������ �� �������� ��������
        Form1.cbLocation.Items.Add(IntToStr(Cards^[i].Card_ID));
      end;
      FindClose(SR); // ��������� �����
      Load_Cards := i;
    end; // CT_LOCATION

  end;

end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 0
  then gCurrent_phase := 1;
  if RadioGroup1.ItemIndex = 1
  then gCurrent_phase := 2;
  if RadioGroup1.ItemIndex = 2
  then gCurrent_phase := 3;
  if RadioGroup1.ItemIndex = 3
  then gCurrent_phase := 4;
  if RadioGroup1.ItemIndex = 4
  then gCurrent_phase := 5;
end;

function TCard.GetLokation;
begin
  GetLokation := StrToInt(Copy(Card_Data, 0, 2));
end;

function TCard.GetNom;
begin
  GetNom := StrToInt(Copy(Card_Data, 2, 2));
end;

// �����������
constructor TCard.Create;
begin
  Card_ID := 0;
  Card_Type := 0;
  Card_Data := '';
end;

// ���������� TCard
destructor TCard.Destroy;
begin
  inherited;
end;

// ��������� ID �����
function TCard.Get_Card_ID;
begin
  Get_Card_ID := Card_ID;
end;

// ���������� �������� �����
Procedure TCard.Dejstvie_karti;
var
  Action_Type: integer;
begin
  // � ����������� �� ����
  case Card_Type of
    CT_DEJSTVIE:;
    CT_KONTAKT:
    begin
      Action_Type := StrToInt(Card_Data[4]);
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
      Form1.lblPrm1.Caption := Form1.ComboBox1.Text;
      Form1.lblPrm2.Caption := Copy(Form1.ComboBox1.Text, 2, 2);
      Form1.lblPrm3.Caption := Card_Data[1];
      Form1.lblPrm4.Caption := Card_Data[4];
      //lblPrm5.Caption := Card_Data[6];
      case StrToInt(Card_Data[6]) of
        0: Form1.lblPrm5.Caption := '����';
        1: Form1.lblPrm5.Caption := '�����';
        2: Form1.lblPrm5.Caption := '���� ��������';
        3: Form1.lblPrm5.Caption := '�����';
        4: Form1.lblPrm5.Caption := '�������� �����';
      end;
      Form1.lblPrm6.Caption := Card_Data[7];
      Form1.lblCardData.Caption := Card_Data;
    end; // CT_COMMON_ITEM

    CT_UNIQUE_ITEM: begin
      Form1.lblPrm21.Caption := Form1.ComboBox2.Text;
      Form1.lblPrm22.Caption := Copy(Form1.ComboBox2.Text, 2, 2);
      Form1.lblPrm23.Caption := Card_Data[1];
      Form1.lblPrm24.Caption := Card_Data[4];
      //lblPrm5.Caption := Card_Data[6];
      case StrToInt(Card_Data[6]) of
        0: Form1.lblPrm25.Caption := '����';
        1: Form1.lblPrm25.Caption := '�����';
        2: Form1.lblPrm25.Caption := '���� ��������';
        3: Form1.lblPrm25.Caption := '�����';
        4: Form1.lblPrm25.Caption := '�������� �����';
      end;
      Form1.lblPrm26.Caption := Card_Data[7];
      Form1.lblCardData2.Caption := Card_Data;
    end; // CT_COMMON_ITEM

    CT_LOCATION: begin
      Form1.lblPrm21.Caption := Form1.ComboBox2.Text;
      Form1.lblPrm22.Caption := Copy(Form1.ComboBox2.Text, 2, 2);
      Form1.lblPrm23.Caption := Card_Data[1];
      Form1.lblPrm24.Caption := Card_Data[4];
      //lblPrm5.Caption := Card_Data[6];
      case StrToInt(Card_Data[6]) of
        0: Form1.lblPrm25.Caption := '����';
        1: Form1.lblPrm25.Caption := '�����';
        2: Form1.lblPrm25.Caption := '���� ��������';
        3: Form1.lblPrm25.Caption := '�����';
        4: Form1.lblPrm25.Caption := '�������� �����';
      end;
      Form1.lblPrm26.Caption := Card_Data[7];
      Form1.lblCardData2.Caption := Card_Data;
    end; // CT_COMMON_ITEM
  end;
end;

// ������� ������
procedure TCard.Shuffle();
begin

end;

// �������������
// ����� �������������, ������ ���� ����� ���������
// � ���� ��� ����� ������������� ����
procedure TForm1.Button2Click(Sender: TObject);
var
  i: integer;
  PlStats: array [1..6] of integer;
begin
  PlStats[1] := 5; // Speed
  PlStats[2] := 1; // Sneak
  PlStats[3] := 4; // Fight
  PlStats[4] := 0; // Will
  PlStats[5] := 5; // Lore
  PlStats[6] := 0; // Luck
  // �������� ������� ������
  gPlayer := TPlayer.Create(PlStats, False);
  

  // �������� ���� n-�� ���� (��������)

  // �������� ���� ������� ���������
  Common_Items_Count := Load_Cards(CT_COMMON_ITEM, @Common_Items_Deck);

  // �������� ���� ���������� ���������
  Unique_Items_Count := Load_Cards(CT_UNIQUE_ITEM, @Unique_Items_Deck);

  // �������� ���� �������
  Locations_Count := Load_Cards(CT_LOCATION, @Locations_Deck);

  // � �.�.
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i: integer;
begin
  lblPlrStamina.Caption := IntToStr(gPlayer.Get_Stamina);
  lblPlrSanity.Caption := IntToStr(gPlayer.Get_Sanity);
  lblPlrFocus.Caption := IntToStr(gPlayer.Get_Focus);
  lblStatSpeed.Caption := IntToStr(gPlayer.Stats[1]);
  lblStatSneak.Caption := IntToStr(gPlayer.Stats[2]);
  lblStatFight.Caption := IntToStr(gPlayer.Stats[3]);
  lblStatWill.Caption := IntToStr(gPlayer.Stats[4]);
  lblStatLore.Caption := IntToStr(gPlayer.Stats[5]);
  lblStatLuck.Caption := IntToStr(gPlayer.Stats[6]);
  ListBox1.Clear;
  //for i := 1 to gPlayer.Get_Items_Count do
  //  ListBox1.Items.Add(IntToStr(gPlayer.Get_Item(i)));
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  Image1.Picture.LoadFromFile('..\Gofy\CardsData\CommonItems\'+ComboBox1.Text+'.jpg');
  Common_Items_Deck[ComboBox1.ItemIndex+1].Dejstvie_karti;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
//  cards0[StrToInt(ComboBox1.Text)].Dejstvie_karti;
  if ComboBox1.ItemIndex < 1 then
    ShowMessage('�������� �����')
  else
    gPlayer.Draw_Card(StrToInt(ComboBox1.Text));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  pl: TPlayer;
begin

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
//  gPlayer.Free;
  for i := 1 to 100 do
  begin
    //Cards0[i].Free;
    //Common_Items_Deck[i].Free;
    //Unique_Items_Deck[i].Free;
    //Locations_Deck[i].Free;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i,r: integer;
  temp: TCard;
begin
  randomize;
  for i := 1 to 21 do
  begin
    temp := Common_Items_Deck[i];
    r := random(21);
    Common_Items_Deck[i] := Common_Items_Deck[r+1];
  end;
  //Common_Items_Deck.Shuffle;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to 100 do
  begin
    Cards0[i] := TCard.Create;
    Common_Items_Deck[i]:= TCard.Create;
    Unique_Items_Deck[i]:= TCard.Create;
    Locations_Deck[i]:= TCard.Create;
  end;

  for i := 1 to 16 do
  begin
    cbLocation.Items.Add(TLocationName[i]);
  end;
end;

procedure TForm1.btnRollADieClick(Sender: TObject);
var
  i: integer;
  s, ns: integer;
begin
  s := gPlayer.RollADice(gPlayer, StrToInt(Copy(Get_Card_By_ID(@Locations_Deck, StrToInt(cbLocation.Text)).Get_Card_Data, 9, 1)));
  ns := StrToInt(Copy(Get_Card_By_ID(@Locations_Deck, StrToInt(cbLocation.Text)).Get_Card_Data, 10, 1));
  if s >= ns then
    ShowMessage('Success!');
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if ComboBox2.ItemIndex < 1 then
    ShowMessage('�������� �����')
  else
    gPlayer.Draw_Card(StrToInt(ComboBox2.Text));
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  Image2.Picture.LoadFromFile('..\Gofy\CardsData\UniqueItems\'+ComboBox2.Text+'.jpg');
  Unique_Items_Deck[ComboBox2.ItemIndex+1].Dejstvie_karti;
end;

procedure TForm1.cbLocationChange(Sender: TObject);
var
  LocNum: integer;
begin
  LocNum := StrToInt(Copy(cbLocation.Text, 2, 1));
  lblLocID.Caption := IntToStr(LocNum);
  lblLocCardData.Caption := Get_Card_By_ID(@Locations_Deck, StrToInt(cbLocation.Text)).Get_Card_Data;
  lblNumSuccesses.Caption := Copy(Locations_Deck[cbLocation.ItemIndex + 1].Get_Card_Data, 9, 3);
  case StrToInt(Copy(Get_Card_By_ID(@Locations_Deck, StrToInt(cbLocation.Text)).Get_Card_Data, 9, 1)) of
  1: lblSkill.Caption := '��������';
  2: lblSkill.Caption := '����������';
  3: lblSkill.Caption := '����';
  4: lblSkill.Caption := '����';
  5: lblSkill.Caption := '������';
  6: lblSkill.Caption := '�����';
  7: lblSkill.Caption := '����';
  8: lblSkill.Caption := '�����';
  end;
  imEncounter.Picture.LoadFromFile('..\\Gofy\\CardsData\\Locations\\'+cbLocation.Text[1]+'0'+cbLocation.Text[3]+cbLocation.Text[4]+'.jpg');
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  case cbLocation.ItemIndex of
  0: ShowMessage('''Listen!'' An old man with a piercing gaze locks eyes with you, and you feel strange information squirming around in your head. Pass a Will (-1) check to gain 1 Spell.');
  1: ;//ShowMessage('''Listen!'' An old man with a piercing gaze locks eyes with you, and you feel strange information squirming around in your head. Pass a Will (-1) check to gain 1 Spell.');
  2: ;
  3:  ;
  4:   ;
  5:    ;
  6:     ;
  7:      ;
  8:       ;
  9:       ;
  10:       ;
  11:        ;
  12:         ;
  13:          ;
  14:           ;
  15:            ;
  16:             ;
  end;
end;

end.
