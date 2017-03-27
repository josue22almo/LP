#header
<<
#include <string>
#include <iostream>
using namespace std;

// struct to store information about tokens
typedef struct {
  string kind;
  string text;
} Attrib;

// function to fill token information (predeclaration)
void zzcr_attr(Attrib *attr, int type, char *text);

// fields for AST nodes
#define AST_FIELDS string kind; string text;
#include "ast.h"

// macro to create a new AST node (and function predeclaration)
#define zzcr_ast(as,attr,ttype,textt) as=createASTnode(attr,ttype,textt)
AST* createASTnode(Attrib* attr, int ttype, char *textt);
>>

<<
#include <cmath>
#include <map>
#include <vector>
// function to fill token information
void zzcr_attr(Attrib *attr, int type, char *text) {
    attr->kind = text;
    attr->text = "";
}

// function to create a new AST node
AST* createASTnode(Attrib* attr, int type, char* text) {
  AST* as = new AST;
  as->kind = attr->kind; 
  as->text = attr->text;
  as->right = NULL; 
  as->down = NULL;
  return as;
}

/// create a new "list" AST node with one element
AST* createASTlist(AST *child) {
 AST *as=new AST;
 as->kind="list";
 as->right=NULL;
 as->down=child;
 return as;
}

/// get nth child of a tree. Count starts at 0.
/// if no such child, returns NULL
AST* child(AST *a,int n) {
 AST *c=a->down;
 for (int i=0; c!=NULL && i<n; i++) c=c->right;
 return c;
} 

int numChilds(AST *a) {
 AST *c=a->down;
 int i;
 for (i=0; c!=NULL; i++) c=c->right;
 return i;
}

/// print AST, recursively, with indentation
void ASTPrintIndent(AST *a,string s)
{
  if (a==NULL) return;

  cout<<a->kind;
  if (a->text!="") cout<<"("<<a->text<<")";
  cout<<endl;

  AST *i = a->down;
  while (i!=NULL && i->right!=NULL) {
    cout<<s+"  \\__";
    ASTPrintIndent(i,s+"  |"+string(i->kind.size()+i->text.size(),' '));
    i=i->right;
  }
  
  if (i!=NULL) {
      cout<<s+"  \\__";
      ASTPrintIndent(i,s+"   "+string(i->kind.size()+i->text.size(),' '));
      i=i->right;
  }
}

/// print AST 
void ASTPrint(AST *a)
{
  while (a!=NULL) {
    cout<<" ";
    ASTPrintIndent(a,"");
    a=a->right;
  }
}

struct Tube{
    string id;
    int length;
    int diameter;
    bool valid;
};

struct Connector{
    string id;
    int diameter;
    bool valid;
};

struct Error{
    int line;
    string text;
};

typedef map<string, Tube> Tubes;
typedef map<string, Connector> Connectors;
typedef vector<Error> Errors;

Tubes tubes;
Connectors connectors;
Errors errors;

void printLengthDiameter(AST *c, AST *id, int size){
    cout << "The " << c->kind << " of " << id->kind << " is " << size << "." << endl;    
}

void printTube(){
    cout << "At the end of the execution following variables are the available tubes."<< endl;
    for(map<string, Tube >::iterator it = tubes.begin(); it != tubes.end(); ++it){
        if (it->second.valid)
            cout << it->second.id << " " << it->second.length << " " << it->second.diameter << endl;
    }
    cout << "-------------------------" << endl << "-------------------------" << endl;
}

void printConnectors(){
    cout << "At the end of the execution following variables are the available connectors."<< endl;
    for(map<string, Connector >::iterator it = connectors.begin(); it != connectors.end(); ++it){
       if (it->second.valid)
            cout << it->second.id << " " << it->second.diameter << endl;
    }
    cout << "-------------------------" << endl << "-------------------------" << endl;
}

void printErrors(){
    cout << "ERRORS FOUNDS: ";
    for (int i = 0; i < errors.size(); ++i){
        cout << "Error in line " << errors[i].line << ". " << errors[i].text << endl;
    }
    cout << "-------------------------" << endl << "-------------------------" << endl;
}

bool isDigit (char c){
    return ( '0' <= c && c <= '9' );
}

void saveError (string msg, int line){
    Error e;
    e.line = line;
    e.text = msg;
    errors.push_back(e);
}

void errorNotDeclare(AST *c, int line){
    saveError(c->kind + " has not declared in this scope.",line);
}

int getSize (AST *a, int line){
    string id = a->kind;
    if (isDigit(id[0])) return atoi(id.c_str());
    else{ //tenemos el size de un ID (connector o tube)
        AST *c = child(a,0);
        if (id == "LENGTH"){ //buscamos el length del ID
            if (tubes.find(c->kind) != tubes.end()){ //es un tubo
                return tubes.find(c->kind)->second.length;
            }else if (connectors.find(c->kind) != connectors.end()){ 
                //error, un connector no tiene length, si no diameter
                saveError(c->kind + " is a CONNECTOR. CONNECTOR has no length", line);
                return -1;
            }else{
                errorNotDeclare(c,line);
                return -1;
            }
        }else{ //DIAMETER
            if (tubes.find(c->kind) != tubes.end()){ //es un tubo
                return tubes.find(c->kind)->second.diameter;
            }else if (connectors.find(c->kind) != connectors.end()){ 
                //error, un tubo no tiene length, si no diameter
                return connectors.find(c->kind)->second.diameter;;
            }else{
                errorNotDeclare(c,line);
                return -1;
            }
        }
    }
}

Tube createTube (AST *aId, AST *aSize, int line){
    Tube tube;
    tube.id = aId->kind;
    tube.length = getSize(child(aSize,0),line);
    tube.diameter = getSize(child(aSize,1),line);
    tube.valid = (tube.length != -1 && tube.diameter != -1);
    return tube;
}

Tube merge (AST *id, AST *mg, int line){
    cout << "ini" << endl;
    Tube newTube;
    cout << "1" << endl;
    AST *t1 = child(mg,0);
    cout << "2" << endl;
    AST *con = child(mg,1);
    cout << "3" << endl;
    AST *t2 = child(mg,2);
    cout << "4" << endl;
    Tube tube1, tube2;
    Connector connector;
    tube1.valid = tube2.valid = connector.valid = false;
    //Find the first TUBE
    if (t1->kind == "MERGE"){ tube1 = merge(NULL,t1,line); cout << "5" << endl;}
    else{
        if (tubes.find(t1->kind) != tubes.end())
            tube1 = tubes.find(t1->kind)->second;
        else 
            errorNotDeclare(t1,line);
    }
    //Getting the connector
    if (connectors.find(con->kind) != connectors.end())
            connector = connectors.find(t2->kind)->second;
    else 
        errorNotDeclare(con,line);  
    //Getting the second TUBE
    cout << "hear 1" << endl;
    if (t2->kind == "MERGE"){ tube2 = merge(NULL,t2,line); cout << "6" << endl;}
    else{
        if (tubes.find(t2->kind) != tubes.end())
            tube2 = tubes.find(t2->kind)->second;
        else 
            errorNotDeclare(t2,line);
    }
    cout << "hear2 " << endl;
    //Computing the new tube if possigble
    if (tube1.diameter != connector.diameter || tube1.diameter != tube2.diameter || connector.diameter != tube2.diameter)
        //saveError("The parameters of MERGE have diferents diameter", line);
    return newTube;
}

Connector createConnector (AST *aId, AST *aSize, int line){
    Connector connector;
    connector.id = aId->kind;
    connector.diameter = getSize(child(aSize,0),line);
    connector.valid = (connector.diameter != -1);
    return connector;
}

pair<Tube,Tube> split(AST *a, int line){
    pair<Tube,Tube> newTubes;
    newTubes.first.valid = newTubes.second.valid = false;
    if (tubes.find(a->kind) != tubes.end()){
        Tube tube = tubes.find(a->kind)->second;
        tubes.find(a->kind)->second.valid = false;
        int newLength = tube.length/2;
        newTubes.first.length = newTubes.second.length = newLength;
        newTubes.first.diameter = newTubes.second.diameter = tube.diameter;
        newTubes.first.valid = newTubes.second.valid = true;
        if (tube.length % 2 != 0){
            ++newTubes.second.length;
        }
    }else errorNotDeclare(a,line);
    return newTubes;
}

void normalAssignation(AST *id, AST *value, int line){
    if (tubes.find(value->kind) != tubes.end()){
        map<string, Tube >::iterator it  = tubes.find(value->kind);
        Tube newTube;
        newTube.id = id->kind;
        newTube.length = it->second.length;
        newTube.diameter = it->second.diameter;
        tubes.erase(value->kind);
        tubes.insert(pair<string,Tube>(newTube.id,newTube));
    }else if (connectors.find(value->kind) != connectors.end()){
        map<string, Connector >::iterator it  = connectors.find(value->kind);
        Connector newConnector;
        newConnector.id = id->kind;
        newConnector.diameter = it->second.diameter;
        connectors.erase(value->kind);
        connectors.insert(pair<string,Connector>(newConnector.id,newConnector));
    }else{
        errorNotDeclare(value,line);
    }
}

void evaluateAST (AST *a){
    int nChild = 0;
    AST *currentChild;
    while (nChild < numChilds(a)){
        currentChild = child(a,nChild);
        int nChilds = numChilds(currentChild);
        if (nChilds == 3){//SPLIT
            AST *id1 = child(currentChild,0);
            AST *id2 = child(currentChild,1);
            AST *sp = child(currentChild,2); //kind = SPLIT
            pair<Tube,Tube> newTubes = split(sp->down,nChild+1);
            if (newTubes.first.valid == true){
                newTubes.first.id = id1->kind;
                newTubes.second.id = id2->kind;
                tubes.insert(pair<string,Tube>(id1->kind,newTubes.first));
                tubes.insert(pair<string,Tube>(id2->kind,newTubes.second));
            }
        }
        else if (nChilds == 2){ //TUBE , CONNECTOR , WHILE
            if (currentChild->kind == "="){ //AN ASSIGNATION
                AST *id = child(currentChild,0); //es el ID
                AST *value = child(currentChild,1); //value
                string kind = value->kind;
                if (kind == "TUBE"){
                    Tube newTube = createTube(id,value, nChild+1);           
                    if (newTube.valid)
                        tubes.insert(pair<string,Tube>(newTube.id,newTube));
                }
                else if (kind == "CONNECTOR"){
                    Connector newConnector = createConnector(id,value,nChild+1);
                    if (newConnector.valid)
                        connectors.insert(pair<string,Connector>(newConnector.id,newConnector));
                }else if (kind == "MERGE"){
                    Tube newTube = merge(id,value,nChild+1);
                    if (newTube.valid) 
                        tubes.insert(pair<string,Tube>(newTube.id,newTube));
                }
                else {//normal assignation
                    normalAssignation(id,value,nChild+1);
                }                
            }
        }else if (nChilds == 1){ //LENGTH OR DIAMETER
            AST *id = child(currentChild,0);
            int size = getSize(currentChild,nChild+1);
            if (size != -1)
                printLengthDiameter(currentChild,id,size);
        }
        ++nChild;
    }
    cout << "Execution is done" << endl;
    cout << "-------------------------" << endl << "-------------------------" << endl;
}

int main() {
  AST *root = NULL;
  ANTLR(plumber(&root), stdin);
  //ASTPrint(root);
  evaluateAST(root);
  printTube();
  printConnectors();
  printErrors();
}
>>

#lexclass START
//...
#token NUM "[0-9]+"
#token PLUS "\+"
#token MINUS "\-"
#token PRODUCT "\*"
#token GREATER "\>"
#token SMALLER "\<"
#token EQUAL_EQUAL "\=="
#token ASSIG "\="
#token O_BRACKET "\("
#token C_BRACKET "\)"
#token COMA "\,"
#token TUBE "TUBE"
#token SPLIT "SPLIT"
#token CONNECTOR "CONNECTOR"
#token MERGE "MERGE"
#token LENGTH "LENGTH"
#token DIAMETER "DIAMETER"
#token TUBEVECTOR "TUBEVECTOR"
#token OF "OF"
#token PUSH "PUSH"
#token POP "POP"
#token WHILE "WHILE"
#token ENDWHILE "ENDWHILE"
#token NOT "NOT"
#token AND "AND"
#token OR "OR"
#token FULL "FULL"
#token EMPTY "EMPTY"
#token ID "[a-zA-z0-9]+"
#token SPACE "[\ \n]" << zzskip();>>

plumber: (ops)* <<#0=createASTlist(_sibling);>>;
//...
ops: assigment | length | diameter | loop | push | pop;
//assigment 
assigment: name ASSIG^ assigment_value;
name: ID | (O_BRACKET! ID COMA! ID C_BRACKET!);
//assigment_value
assigment_value: aritmetic | tube | split | connector | merge | tubevector;
//aritmetic
aritmetic: a_term ((PLUS^ | MINUS^) a_term)*;
a_term: ID (PRODUCT^ ID)*;
tube: TUBE^ size size;
split: SPLIT^ ID;
connector: CONNECTOR^ size;
merge: MERGE^ term term term;
tubevector: TUBEVECTOR^ OF size;
term: ID | merge;
size: NUM | length | diameter;

//length and diameter
length: LENGTH^ O_BRACKET! ID C_BRACKET!;
diameter: DIAMETER^ O_BRACKET! ID C_BRACKET!;

//loop 
loop: WHILE^ O_BRACKET! exp C_BRACKET! plumber ENDWHILE!;
//boolean expression -> AND al mismo nivel que una OR (AND es prioritaria)
exp: signed_term ((OR^ | ) exp)*;
signed_term: ( | NOT^) b_term ( | AND^ signed_term);
b_term: argument | (O_BRACKET! exp C_BRACKET!);
argument: (size (GREATER^ | SMALLER^ | EQUAL_EQUAL^) size) | empty_full;
empty_full: (FULL^ | EMPTY^) O_BRACKET! ID C_BRACKET!;

//push and pop
push: PUSH^ ID ID;
pop: POP^ ID ID;
