unit U_Login;

interface

uses
  {$IFDEF VER210} //Vers�o 2010
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, FMTBcd, DB, SqlExpr, IBCustomDataSet,
  IBQuery, DBCtrls;
  {$ELSE}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IBCustomDataSet, Data.DB, IBQuery, Vcl.DBCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Imaging.jpeg;
  {$ENDIF} //Versao XE2

type
  TF_Login = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EdtSenha: TEdit;
    BtnConfirmar: TBitBtn;
    BtnCancelar: TBitBtn;
    QUsuarios: TIBQuery;
    QLogin: TIBQuery;
    Ds_Usuarios: TDataSource;
    lkp_users: TDBLookupComboBox;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnConfirmarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Login: TF_Login;

implementation

uses U_Principal, U_DM;

{$R *.dfm}

procedure TF_Login.BtnCancelarClick(Sender: TObject);
begin
  Close; //Fecha o form
end;

procedure TF_Login.BtnConfirmarClick(Sender: TObject);
begin
  if (lkp_users.KeyValue <> -1) and (Trim(EdtSenha.Text) <> EmptyStr) then //Verifica se o usu�rio selecionou um login e digitou uma senha
  begin
    QLogin.Close;
    QLogin.ParamByName('CODIGO').AsInteger := lkp_users.KeyValue;
    QLogin.ParamByName('SENHA').AsString := Trim(EdtSenha.Text);
    QLogin.Open; //Pesquisa o usu�rio selecionado no banco

    if QLogin.RecordCount > 0 then //se existir - faz login
    begin
      F_Principal.CodUsuario := QLogin.FieldByName('FUN_CODIGO').AsString;
      F_Principal.NomeUsuario := QLogin.FieldByName('FUN_LOGIN').AsString;
      F_Principal.Show;
      F_Login.ModalResult:= mrOK;
      Self.Hide;
    end
    else //se n�o existir - da mensagem de usu�rio n�o encontrado
    begin
      Application.MessageBox('Usu�rio e/ou Senha inv�lidos.','Aviso',MB_OK + MB_ICONWARNING);
      EdtSenha.Clear;
      EdtSenha.SetFocus;
      Exit;
    end;
  end
  else
  begin
    Application.MessageBox('� necess�rio preencher o usu�rio e a senha!','Aten��o',MB_OK + MB_ICONWARNING);
    lkp_users.SetFocus;
  end;
end;

procedure TF_Login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TF_Login.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then //Se pressionar ENTER - Clica no bot�o confirmar
    BtnConfirmar.Click;

  if Key = #27 then //Se pressionar ESC - Clica no bot�o cancelar
    BtnCancelar.Click;
end;

procedure TF_Login.FormShow(Sender: TObject); //Ao abrir o form, carrega os usu�rios
begin
  QUsuarios.Close;
  QUsuarios.Open;
  QUsuarios.FetchAll;
end;

end.
