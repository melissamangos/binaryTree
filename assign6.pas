{ Melissa Mangos }
{ May 31, 2013 }
{ This program simulates bank data in a binary tree }
program BankData;
uses wincrt;

{ Assign record }
type
   TClientPtr = ^TClient;

   TClient = record
      FirstName: string[15];
      LastName : string[30];
      Phone : string[12];
      Savings, Chequings, GICs, Bonds, Mutual : real;
      pLeft, pRight, pParent : TClientPtr;
   end; { TStudent } 

{ Global Variable Declarations }
var
   pRoot : TClientPtr;

{ METHODS --------------------------------------------------------------------- }

{ Determines if child is to the left or right of given parent }
function LeftOrRight (pChild, pParent : TClientPtr) : string;
{ Variable Declarations }
var
   direction : string;
begin
   if (pChild^.LastName < pParent^.LastName) or
      ((pChild^.LastName = pParent^.LastName) and (pChild^.FirstName < pParent^.FirstName)) then
   { Child is to the left }
   begin
      direction := 'Left';
   end
   else if (pChild^.LastName > pParent^.LastName) or
           ((pChild^.LastName = pParent^.LastName) and (pChild^.FirstName > pParent^.FirstName)) then
   { Child is to the right }
   begin
      direction := 'Right';
   end; { if }

   { Return direction }
   LeftOrRight := direction;
end; { LeftOrRight }

{ Searches for a client }
function SearchClient (pCurrent, pSearch : TClientPtr) : TClientPtr;
{ Variable Declarations }
var
   direction : string;
begin
   { Finds a client or the parent if client is no found }
   if (pSearch^.LastName <> pCurrent^.LastName) or (pSearch^.FirstName <> pCurrent^.FirstName) then
   begin
      { Find out if child is on parents left or right }
      direction := LeftOrRight (pSearch, pCurrent);

      if (direction = 'Left') then
      begin
         { The fuction is called when not at the bottom of the list }
         if (pCurrent^.pLeft <> nil) then
         begin
            pCurrent := SearchClient (pCurrent^.pLeft, pSearch);
         end; { if }
      end
      else if (direction = 'Right') then
      begin
         { The fuction is called when not at the bottom of the list }
         if (pCurrent^.pRight <> nil) then
         begin
            pCurrent := SearchClient (pCurrent^.pRight, pSearch);
         end; { if }
      end; { if }
   end; { if }

   { Returns client if found, parent if not found }
   SearchClient := pCurrent;
end; { SearchClient }
                     
{ Inserts a new client into the binary tree }
procedure InsertClient (var pNew : TClientPtr);
{ Variable Declarations }
var
   pCurrent : TClientPtr;
   direction : string;
begin
   { Initializes root to first node }
   if (pRoot = nil) then
   begin
      pRoot := pNew;
      pRoot^.pParent := nil;
      pRoot^.pRight := nil;
      pRoot^.pLeft := nil;
   end
   else
   begin
      { Searches for a spot to put the new client }
      pCurrent := SearchClient (pRoot, pNew);

      { If the client does not already exist }
      if (pCurrent^.FirstName <> pNew^.FirstName) or (pCurrent^.LastName <> pNew^.LastName) then
      begin
         { Decides if child is on parents left or right }
         direction := LeftOrRight (pNew, pCurrent);

         { Places the client on the left }
         if (direction = 'Left') then
         begin
            pCurrent^.pLeft := pNew;
         end
         { Places the client on the right }
         else if (direction = 'Right') then
         begin
            pCurrent^.pRight := pNew;
         end;

         { Initializes the new client }
         pNew^.pParent := pCurrent;
         pNew^.pLeft := nil;
         pNew^.pRight := nil;
      end; { if }
   end; { if }
end; { InsertClient }

{ Reads clients from text file into nodes }
procedure ReadFile;
{ Variable Declarations }
var
   pNew : TClientPtr;
   fo : text;
begin
   { Open text file }
   assign (fo, 'clients.txt');
   reset (fo);

   { Initialize an empty list }
   pRoot := nil;

   while (not (eof (fo))) do
   begin
      { Create a new node by reading text file }
      new (pNew);
      readln (fo, pNew^.FirstName);
      readln (fo, pNew^.LastName);
      readln (fo, pNew^.Phone);
      readln (fo, pNew^.Savings);
      readln (fo, pNew^.Chequings);
      readln (fo, pNew^.GICs);
      readln (fo, pNew^.Bonds);
      readln (fo, pNew^.Mutual);

      { Inserts the client from text file }
      InsertClient (pNew);
   end; { while }
end; { ReadFile }

{ Displays a given client's information }
procedure DisplayClient (pClient : TClientPtr);
begin
   writeln ('');
   writeln (pClient^.FirstName);
   writeln (pClient^.LastName);
   writeln (pClient^.Phone);
   writeln ('Savings Account: ', pClient^.Savings : 8 : 2);
   writeln ('Chequing Account: ', pClient^.Chequings : 8 : 2);
   writeln ('G.I.C.s: ', pClient^.GICs : 8 : 2);
   writeln ('Bonds: ', pClient^.Bonds : 8 : 2);
   writeln ('Mutual Funds: ', pClient^.Mutual : 8 : 2);
end; { DisplayClient }

{ Deletes a given client }
procedure DeleteClient (var pClient : TClientPtr);
{ Variable Declarations }
var
   pReplace : TClientPtr;
   direction : string;
begin
   { Checks if client is on left or right of parent }
   direction := LeftOrRight (pClient, pClient^.pParent);

   if (pClient^.pLeft = nil) and (pClient^.pRight = nil) then
   { Leaf node }
   begin
      if (direction = 'Left') then
      { Left side of parent }
      begin
         pClient^.pParent^.pLeft := nil;
      end
      else if (direction = 'Right') then
      { Right side of parent }
      begin
         pClient^.pParent^.pRight := nil;
      end; { if }
   end
   else if (pClient^.pLeft <> nil) and (pClient^.pRight = nil) then
   { One child on left }
   begin
      if (direction = 'Left') then
      { Left side of parent }
      begin
         { Sets parents left to child }
         pClient^.pParent^.pLeft := pClient^.pLeft;
      end
      else if (direction = 'Right') then
      { Right side of parent }
      begin
         { Sets parents right to child }
         pClient^.pParent^.pRight := pClient^.pLeft;
      end; { if } 
      { Sets child's parent to client' s parent }
      pClient^.pLeft^.pParent := pClient^.pParent;
   end
   else if (pClient^.pRight <> nil) and (pClient^.pLeft = nil) then
   { One child on right }
   begin
      if (direction = 'Left') then
      { Left side of parent }
      begin
         { Sets parents left to child }
         pClient^.pParent^.pLeft := pClient^.pRight;
      end
      else if (direction = 'Right') then
      { Right side of parent }
      begin
         { Sets parents right to child }
         pClient^.pParent^.pRight := pClient^.pRight;
      end; { if }
      { Sets child's parent to client's parent }
      pClient^.pRight^.pParent := pClient^.pParent;
   end
   else if (pClient^.pLeft <> nil) and (pClient^.pRight <> nil) then
   { Two children }
   begin
      { Replaces node with next alphabetically }
      pReplace := pClient^.pRight;
      while (pReplace^.pLeft <> nil) do
      begin
         pReplace := pReplace^.pLeft;
      end; { while }

      { Remove the replacement from its original spot }
      if (pReplace^.pLeft = nil) and (pReplace^.pRight = nil) then
      { Leaf node }
      begin
         pReplace^.pParent^.pLeft := nil;
      end
      else if (pReplace^.pLeft = nil) then
      { Child on the right }
      begin
         pReplace^.pParent^.pLeft := pReplace^.pRight;
         pReplace^.pRight^.pParent := pReplace^.pParent;
      end
      else if (pReplace^.pRight = nil) then
      { Child on the left }
      begin
         pReplace^.pParent^.pLeft := pReplace^.pLeft;
         pReplace^.pLeft^.pParent := pReplace^.pParent;
      end; { if }

      { Set the replacement to equal the deleted node }
      if (direction = 'Left') then
      { Left side of parent }
      begin
         pClient^.pParent^.pLeft := pReplace;
      end
      else if (direction = 'Right') then
      { Right side of parent }
      begin
         pClient^.pParent^.pRight := pReplace;
      end; { if }

      { Initializes Replacement }
      pReplace^.pParent := pClient^.pParent;
      pReplace^.pLeft := pClient^.pLeft;
      pReplace^.pRight := pClient^.pRight; 
   end; { if }

   { Dispose node }
   dispose (pClient);
end; { DeleteClient }

{ Displays the clients in alphabetical order }
procedure AlphaClient (pClient : TClientPtr);
begin
   if (pClient^.pLeft <> nil) then
   { Displays on the left using recursion }
   begin
      AlphaClient (pClient^.pLeft);
   end; { if }

   { Display Client }
   write (pClient^.FirstName, ' ', pClient^.LastName, '   ');

   if (pClient^.pRight <> nil) then
   { Displays on right using recursion }
   begin
      AlphaClient (pClient^.pRight);
   end; { if }
end;

{ MAIN PROGRAM ---------------------------------------------------------------- }

{ Variable Decalrations }
var
   pSearch, pClient, pNew : TClientPtr;
   answer, alpha : string;
begin
   { Reads Text file and calls input and search functions }
   ReadFile;

   { Creates a new node to be searched }
   new (pSearch);

   while (alpha <> 'Yes') do
   begin                                                  
      { Inputs a person to search }
      write ('Enter the client''s first name: ');
      readln (pSearch^.FirstName);
      write('Enter the client''s last name: ');
      readln (pSearch^.LastName);

      { Searches for the person }
      pClient := SearchClient (pRoot, pSearch);

      if (pClient^.FirstName = pSearch^.FirstName) and (pClient^.LastName = pSearch^.LastName) then
      { If found }
      begin 
         { Displays the person's information }
         DisplayClient (pClient);

         { Asks to delete client }
         writeln ('');
         write ('Would you like to delete the client (Yes or No)? ');
         readln (answer);
         if (answer = 'Yes') then
         begin
            { Deletes the client }
            DeleteClient (pClient);
         end;
      end
      else { Client is not found }
      begin
         { Asks to insert a new Client }
         writeln ('');
         write ('Would you like to insert a client (Yes or No)? ');
         readln (answer);
         if (answer = 'Yes') then
         begin
            { Gets new clients information }
            new (pNew);
            pNew^.FirstName := pSearch^.FirstName;
            pNew^.LastName := pSearch^.LastName;
            write ('Phone number? ');
            readln (pNew^.Phone);
            write ('Savings account? ');
            readln (pNew^.Savings);
            write ('Chequing account? ');
            readln (pNew^.Chequings);
            write ('G.I.C.s? ');
            readln (pNew^.GICs);
            write ('Bonds? ');
            readln (pNew^.Bonds);
            write ('Mutual Funds? ');
            readln (pNew^.Mutual);

            { Inserts client into binary tree }
            InsertClient (pNew);
          
            { Displays new client's information }
            DisplayClient (pNew);
         end;
      end; { if }

      { Asks for alphabetical order (exits the loop) } 
      writeln ('');
      write ('Would you like to see the clients alphabetically (Yes to exit)? ');
      readln (alpha);
      writeln ('');
   end;     

   { Displays clients in alphbetical order }
   AlphaClient (pRoot);

end. { program }