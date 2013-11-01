unit Player;

interface
uses
  SysUtils, Dialogs, Card_deck, Unit2;

type
  TPlayer = class
  private
    Cards: array [1..100] of integer; // �������� ������
    Items_Count: integer; // ���-�� ��������� � ������
    bFirst_Player: boolean; // ���� ������� ������
  public
    Sanity: integer;
    Stamina: integer;
    Focus: integer;
    Money: integer;
    Clue_Token: integer;
    Monster_Trophies: integer;
    Location: integer; // id ������� � ���� xxy, ��� (�� - ����� �����, y - ����� �������)
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
    function RollADice(stat: integer): integer;
    procedure EvtMoveToLocation(c_N: integer; c_data: string);
    procedure Encounter(var Locations_Deck: TCardDeck);
    procedure Take_Action(c_Action1: integer; c_Action1Value: integer);
    function CheckAvailability(grade: integer; param: integer): boolean;
    function HasItem(ID: integer): boolean;
    //property Speed: integer read Stats[1] write Stats[1];
  end;

implementation

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
function TPlayer.RollADice(stat: integer): integer;
var
  r, i: integer;
  Roll_results: array [1..12] of integer;
  Successes: integer;
begin
  randomize;
  Successes := 0;
  //Form1.imDie1.Picture.LoadFromFile('..\\Gofy\\Pictures\\0.jpg');
  //Form1.imDie2.Picture.LoadFromFile('..\\Gofy\\Pictures\\0.jpg');
  //Form1.imDie3.Picture.LoadFromFile('..\\Gofy\\Pictures\\0.jpg');
  //Form1.imDie4.Picture.LoadFromFile('..\\Gofy\\Pictures\\0.jpg');
  //Form1.imDie5.Picture.LoadFromFile('..\\Gofy\\Pictures\\0.jpg');
  //Form1.imDie6.Picture.LoadFromFile('..\\Gofy\\Pictures\\0.jpg');
  //Form1.imDie7.Picture.LoadFromFile('..\\Gofy\\Pictures\\0.jpg');
  //RollADice := random(6)+1;
    //pl := TPlayer.Create(False);
  if Stats[stat] > 0 then
  begin
    for i:=1 to Stats[stat] do
    begin
      Roll_results[i]:=random(6)+1;
      {case Roll_results[i] of
      1: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\1.jpg');
      2: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\2.jpg');
      3: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\3.jpg');
      4: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\4.jpg');
      5: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\5.jpg');
      6: (Form1.FindComponent('imDie'+IntToStr(i)) as TImage).Picture.LoadFromFile('..\\Gofy\\Pictures\\6.jpg');
      end; }

      if Roll_results[i]>=5 then
      begin
        Successes := Successes + 1;
        //broskub.usp:=true;
        //broskub.kolusp:=broskub.kolusp+1;
        //if broskub.resbroskub[i]=6 then broskub.kolusp6:=broskub.kolusp6+1;
      end;
    end;
  end;

  //Form1.imDie1.Picture.LoadFromFile('0.jpg');
  RollADice := Successes;
end;

procedure TPlayer.EvtMoveToLocation(c_N: integer; c_data: string);
var
 c_Action1, c_Action1Value: integer;
begin
  // refer to xls file to locs table (n, id)
  if c_N = 0 then
  begin
    form2.ShowModal; // Move to any location
  end
  else
  begin
    Location := 2103;
  end;

  c_Action1 := StrToInt(copy(c_data, 9, 2));
  c_Action1Value := StrToInt(copy(c_data, 14, 2));

  if c_Action1 = 35 then
    ShowMessage('Encounter!');
end;

// ��������� �������
procedure TPlayer.Encounter(var Locations_Deck: TCardDeck);
var
  i: integer;
  s, ns: integer;
  card_data: array [0..71] of integer;
  c_data: string;
  c_Cond1, c_Cond2: integer;
  c_Choise, c_Choise2: integer;
  c_N, c_N2: integer;
  c_NSccssMin, c_NSccssMax, c_NSccssMin2, c_NSccssMax2: integer;
  c_Action1, c_Action2, c_Action3, c_Action21, c_Action22, c_Action23: integer;
  c_Action1Value, c_Action2Value, c_Action3Value,
  c_Action21Value, c_Action22Value, c_Action23Value: integer;
  c_Act1Cond, c_Act2Cond, c_Act21Cond, c_Act22Cond, c_Else1Cond, c_Else2Cond: integer;
  c_Else1, c_Else2, c_Else21, c_Else22: integer;
  c_Else1Value, c_Else2Value, c_Else21Value, c_Else22Value: integer;
  skill_test: integer;
begin
  // TODO: ������� � ������� | N | ID_Card |, ����� �������� ����� ��� �������
  // � ��������� �����

  // �������� ������ �����
  c_data := Locations_Deck.Get_Card_By_ID(Location).Data;
  for i := 0 to Length(c_data)-1 do
    card_data[i] := StrToInt(c_data[i+1]);

  c_Cond1 := StrToInt(copy(c_data, 1, 2));
  c_Choise := StrToInt(copy(c_data, 3, 2));
  c_N := StrToInt(copy(c_data, 5, 1));
  c_NSccssMin := StrToInt(copy(c_data, 6, 1));
  c_NSccssMax := StrToInt(copy(c_data, 7, 1));

  c_Action1 := StrToInt(copy(c_data, 8, 2));
  c_Action1Value := StrToInt(copy(c_data, 10, 1));
  c_Act1Cond := StrToInt(copy(c_data, 11, 1));
  c_Action2 := StrToInt(copy(c_data, 12, 2));
  c_Action2Value := StrToInt(copy(c_data, 14, 1));
  c_Act2Cond := StrToInt(copy(c_data, 15, 1));

  c_Action3 := StrToInt(copy(c_data, 16, 2));
  c_Action3Value := StrToInt(copy(c_data, 18, 1));
  c_Else1 := StrToInt(copy(c_data, 19, 2));
  c_Else1Value := StrToInt(copy(c_data, 21, 1));
  c_Else1Cond := StrToInt(copy(c_data, 22, 1));
  c_Else2 := StrToInt(copy(c_data, 23, 2));
  c_Else2Value := StrToInt(copy(c_data, 25, 1));

  c_Cond2 := StrToInt(copy(c_data, 27, 2));
  c_Choise2 := StrToInt(copy(c_data, 29, 2));
  c_N2 := StrToInt(copy(c_data, 31, 1));
  c_NSccssMin2 := StrToInt(copy(c_data, 32, 1));
  c_NSccssMax2 := StrToInt(copy(c_data, 33, 1));

  c_Action21 := StrToInt(copy(c_data, 34, 2));
  c_Action21Value := StrToInt(copy(c_data, 36, 1));
  c_Act21Cond := StrToInt(copy(c_data, 37, 1));
  c_Action22 := StrToInt(copy(c_data, 38, 2));
  c_Action22Value := StrToInt(copy(c_data, 41, 1));
  c_Act22Cond := StrToInt(copy(c_data, 42, 1));

  c_Action23 := StrToInt(copy(c_data, 43, 2));
  c_Action23Value := StrToInt(copy(c_data, 45, 1));
  c_Else21 := StrToInt(copy(c_data, 46, 2));
  c_Else21Value := StrToInt(copy(c_data, 48, 1));
  c_Else2Cond := StrToInt(copy(c_data, 49, 1));
  c_Else22 := StrToInt(copy(c_data, 50, 2));
  //c_Else22Value := StrToInt(copy(c_data, 52, 1));

  case c_Cond1 of
  1: begin // ���� True
    Take_Action(c_Action1, c_Action1Value);
  end;
  2: begin // �������� �����
    //ShowMessage('��������');
    skill_test := RollADice(c_Choise);
    if (skill_test + c_N >= c_NSccssMin) and
       (skill_test + c_N <= c_NSccssMax) then // c_Choise - ����� ������
      ShowMessage('������ ��������!!')
    else
    begin
      if c_Else1 = 33 then
      begin
        case c_Cond2 of
        1: begin
          ;
        end;
        2: begin // �������� �����
          //ShowMessage('��������');
          if (skill_test + c_N >= c_NSccssMin2) and
            (skill_test + c_N <= c_NSccssMax2) then // c_Choise - ����� ������
           ShowMessage('������ ��������!!')
          else
            ShowMessage('������!!')
        end;
        3: begin // �������� �������
          if CheckAvailability(c_Choise2, c_N2) then //
            ShowMessage('���� ������ ���-��!!')
          else
            ShowMessage('�� �������!!')
          //ShowMessage('�������� �������');
        end;
        4: begin // �������� ���-����
          if c_Choise2 = 8 then
            Money := Money + c_N2;

          if c_Choise2 = 9 then
            Clue_Token := Clue_Token + c_N2;

          if c_Choise2 = 10 then
            Monster_Trophies := Monster_Trophies + c_N2;

          if (c_Choise2 = 11) or (c_Choise2 = 12) then
            Draw_Card(c_N2);
        end;

        5: ShowMessage('���������'); // �������� �������
      end;
    end;
      ShowMessage('������!!')
    end;
  end;
  3: begin // �������� �������
    if CheckAvailability(c_Choise, c_N) then //
      ShowMessage('���� ������ ���-��!!')
    else
      ShowMessage('�� �������!!')
    //ShowMessage('�������� �������');
  end;
  4: begin // �������� ���-����
    if c_Choise = 8 then
      Money := Money + c_N;

    if c_Choise = 9 then
      Clue_Token := Clue_Token + c_N;

    if c_Choise = 10 then
      Monster_Trophies := Monster_Trophies + c_N;

    if (c_Choise = 11) or (c_Choise = 12) then
      Draw_Card(c_N);

  end;

  5: ShowMessage('���������'); // �������� �������

  6: begin // Move to location
    if (c_Choise = 13) then
      EvtMoveToLocation(c_N, c_data);
        //Location := Locations_Deck.Get_Card_ID(c_Action1Value);
        //if c_Action2 <> 0 then

  end;
  end;
end;

// ���������� �������� �������� �����
procedure TPlayer.Take_Action(c_Action1: integer; c_Action1Value: integer);
var
  i: integer;
begin
  case c_Action1 of
  1: Money := Money + c_Action1Value;
  2: Money := Money - c_Action1Value;
  11:
    if c_Action1Value = 0 then
    begin
      //Form2.Show;
      
    end
    else
      Location := StrToInt(IntToStr(Round(c_Action1Value / 3 + 0.4)) + IntToStr(c_Action1Value - (Round(c_Action1Value / 3 + 0.4) - 1) * 3));
  end;
end;

function TPlayer.CheckAvailability(grade: integer; param: integer): boolean;
begin
  if (grade = 8) and (money >= param) then
    result := true;

  if (grade = 9) and (clue_token >= param) then
    result := true;

  if (grade = 10) and (Monster_trophies >= param) then
    result := true;

  result := false;

end;

function TPlayer.HasItem(ID: integer): boolean;
begin

end;

end.
 