
requires "solidity-syntax.k"
requires "configuration.k"

module FUNCTION

imports SOLIDITY-SYNTAX
imports CONFIGURATION


/*****************************@
       FunctionDefinition
*******************************/
 
rule [constructor]: // if we want it, we can also give names to the rules!
  <k> pcsContractPart(C:Id, function C:Id (Ps1:FParameters) FQ:FunQuantifiers returns  (Ps2:FParameters){B}) => . ... </k>
  <Contract>
    <cname> C </cname>
    <cfunction> (.Map => C |-> CF) ... </cfunction> 
    <constructor> _=>1 </constructor> // What if more then one constructor?
    ...
  </Contract>
  <cntfunction> CF:Int => CF +Int 1  </cntfunction>
  (.Bag =>
    <Function>
      <fId> CF </fId>
      <inputparameters> Ps1 </inputparameters>
      <outputparameters> Ps2 </outputparameters>
      <body> B </body>
      <FunQuantifiers> FQ </FunQuantifiers>
      <FunCon> true </FunCon>
      <Return> 0 </Return>
    </Function>)
  requires Id2String(C) =/=String "main"

rule [user-function]:
  <k> pcsContractPart(C:Id, function F:Id (Ps1:FParameters) FQ:FunQuantifiers returns (Ps2:FParameters){B}) => . ... </k>
  // In the other two related rules, the following 3 cells are wrapped inside 
  // 
  //      <Contract>
  //        ...
  //      </Contract>
  //
  // but not here. Is there any special reason for that?
  <cname> C </cname>
  <cfunction> (.Map => F |-> CF) ... </cfunction> // Are you using this Map as a List (or Set)?
  <cntfunction> CF:Int => CF +Int 1  </cntfunction>
  (.Bag =>
    <Function>
      <fId> CF </fId>
      <inputparameters> Ps1 </inputparameters>
      <outputparameters> Ps2 </outputparameters>
      <body> B </body>
      <FunQuantifiers> FQ </FunQuantifiers>
      <FunCon> true </FunCon>
      <Return> 0 </Return>
    </Function>)
  requires (Id2String(F) =/=String "main") andBool 
           (Id2String(F) =/=String Id2String(C))
  // I think we need C != F as a side condition here, otherewise the rule doesn't know that. 
  // It currently works only because previous rule (with C = F) comes first.
  // If the two rules are swapped, it will behave incorrectly.

rule [constructor-no-return-params]:
  <k> pcsContractPart(C:Id, function C:Id (Ps1:FParameters)  FQ:FunQuantifiers  {B}) => . ... </k>
  <Contract>
    <cname> C </cname>
    <cfunction> (.Map => C |-> CF) ... </cfunction>
    <constructor> _=>1 </constructor>
    ...
  </Contract>
  <cntfunction> CF:Int => CF +Int 1  </cntfunction>
  (.Bag =>
    <Function>
      <fId> CF </fId>
      <inputparameters> Ps1 </inputparameters>
      <outputparameters> .FParameters </outputparameters>
      <body> B </body>
      <FunQuantifiers> FQ </FunQuantifiers>
      <FunCon> true </FunCon>
      <Return> 0 </Return>                     
	   </Function>)
  requires Id2String(C) =/=String "main"     
                
rule [user-function-no-return-params]:
  <k> pcsContractPart(C:Id, function F:Id (Ps1:FParameters)  FQ:FunQuantifiers  {B}) => . ... </k>
  <cname> C </cname>	      
  <cfunction> (.Map => F |-> CF) ... </cfunction>
  <cntfunction> CF:Int => CF +Int 1  </cntfunction>
  (.Bag =>
    <Function>
      <fId> CF </fId>
      <inputparameters> Ps1 </inputparameters>
      <outputparameters> .FParameters </outputparameters>
      <body> B </body>
      <FunQuantifiers> FQ </FunQuantifiers>
      <FunCon> true </FunCon>
      <Return> 0 </Return>                     
    </Function>)
  requires Id2String(F) =/=String "main" 
  // Similarly to [user-function], this should also need to state that C =/= F

// Quite a few very similar cases here. May be worth thinking of a way to refactor them at some point?
              
/*
       rule <k> pcsContractPart(C:Id, function .Ids (Ps1:FParameters) FQ:FunQuantifiers   {B}) => . ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => String2Id("fallback")  |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <Function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters>
                     <outputparameters> .FParameters </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <Return> 0 </Return>
	          </Function>
	       )
               
       rule <k> pcsContractPart(C:Id, function .Ids (Ps1:FParameters) FQ:FunQuantifiers returns (Ps2:FParameters) {B}) => . ... </k>
       
	       <cname> C </cname>
	      
               <cfunction> (.Map => String2Id("fallback")  |-> CF) ... </cfunction>
               <cntfunction> CF:Int => CF +Int 1  </cntfunction>
               
               (.Bag =>
	          <Function>
                     <fId> CF </fId>
		     <inputparameters> Ps1 </inputparameters> 
                     <outputparameters> Ps2 </outputparameters>
	  	     <body> B </body>
                     <FunQuantifiers> FQ </FunQuantifiers>
                     <FunCon> true </FunCon>
                     <Return> 0 </Return>
	          </Function>
	       )

*/
                     
rule 
  <k> pcsContractPart(C:Id, function F:Id (Ps1:FParameters) .FunQuantifiers   {B}) => B ... </k>
  <cname> C </cname>
  <cfunction> (.Map => F |-> CF) ... </cfunction>
  <cntfunction> CF:Int => CF +Int 1  </cntfunction>
  (.Bag =>
    <Function>
      <fId> CF </fId>
      <inputparameters> Ps1 </inputparameters>
      <outputparameters> .FParameters </outputparameters>
      <body> B </body>
    ...                    
    </Function>)
  requires Id2String(F) ==String "main"

rule 
  <k> pcsContractPart(C:Id, function F:Id (P1:FParameters) .FunQuantifiers returns (Ps2:FParameters) {B}) => B ... </k>
  <cname> C </cname>
  <cfunction> (.Map => F |-> CF) ... </cfunction>
  <cntfunction> CF:Int => CF +Int 1  </cntfunction>
  (.Bag =>
    <Function>
      <fId> CF </fId>
      <inputparameters> P1 </inputparameters>
      <outputparameters> Ps2 </outputparameters>
      <body> B </body>
      ...
    </Function>)
  requires Id2String(F) ==String "main"

     
//BindParam

         syntax SolidityItem
                  ::=BindParam(FParameters, Values)
      
         rule BindParam(.FParameters, .Values) => .

         rule <k> BindParam(T:TypeName .StorageLocations P:Id, Ps:FParameters, E:Value, Es:Values) => BindParam(Ps,Es) ... </k>
              <contractStack> ListItem(CI:Int) ... </contractStack>
              <contractInstance>
                <ctId> CI </ctId>
                <ctContext> .Map => (P |-> !N:Int) ... </ctContext>
                <ctstore> .Map => (!N:Int |-> E) ... </ctstore>
                ...
              </contractInstance>

//FunQuantifiers
rule FunQs(FQ:FunQuantifier FQs:FunQuantifiers,F:Param) => FunQ(FQ,F) ~> FunQs(FQs,F)
rule FunQs(.FunQuantifiers,F:Param) => .
      
//Specifier
rule FunQ(FQ:Specifier,F:Param) => .
 
//ModifierInvocation
rule 
  <k> FunQ(X:Id, F:Param) => . ... </k>
  <Contract>
    ...
    <mname> X </mname>
    <condition> Con:Expression </condition>
    <cfunction> ... (F |-> CF:Int) ... </cfunction>
  </Contract>            
  <fId> CF </fId>
  <inputparameters> Ps1 </inputparameters> // This is not used, so it could be avoided
  <outputparameters> Ps2 </outputparameters> // This is not used, so it could be avoided
  <body> B:K </body> // This is not used, so it could be avoided
  <FunQuantifiers> FQ </FunQuantifiers> // This is not used, so it could be avoided
  <FunCon> FC:Expression => (FC && Con) </FunCon> // As I mentioned, this is only for a small subset of cases; modifiers can do much more. 
  // General note: those names (CF, FC, FQ etc.) can become confusing :) 
  // ... especially since there's no documentation (will post something on Slack about that)  
      
       
rule 
  <k> FunQ(X:Id (MIPs:Values), F:Param) => BindParam(Ps,MIPs) ... </k>
  <Contract>
    ...
    <mname> X </mname>
    <mparameters> Ps:FParameters </mparameters>
    <condition> Con:Expression </condition>
    <cfunction> ... (F |-> CF:Int) ... </cfunction>
  </Contract>            
  <fId> CF </fId>
  <inputparameters> Ps1 </inputparameters> // This is not used, so it could be avoided
  <outputparameters> Ps2 </outputparameters> // This is not used, so it could be avoided
  <body> B:K </body> // This is not used, so it could be avoided
  <FunQuantifiers> FQ </FunQuantifiers>
  <FunCon> (FC:Expression => (FC && Con)) </FunCon>

//ModifierDefinition

// {require(C:Expression); _;} is only one of the simplest forms of modifier. 
// The construct is actually more general, and it has a few tricky cases, too. 
// It also affects the semantics of the return statement. Unfortunately none of this 
// is explained in the Solidity documentation. 
// The way we found out about those cases was by running at the tests here: 
// https://github.com/ethereum/solidity/blob/develop/test/libsolidity/SolidityEndToEndTest.cpp
// For example, do a text search for "modifier" to see some test cases.

rule [modifier-def]:
  <k> pcsContractPart(CN:Id, modifier X:Id (Ps:FParameters ) {require(C:Expression); _;}) => . ... </k>
  <Contract> // ----> ^^ why don't we make use of CN? 
  (.Bag => 
    <Modifier>
      <mname> X </mname>
      <mparameters> Ps </mparameters>
      <condition> C </condition>
    </Modifier>)
    ...
  </Contract> 
  // ^ What contract is actually picked here? To which contract are we adding the modifier? 
  // Looks like we do not check the contract name, so it can pick anything (or probably the 1st?)!

rule [modifier-def-no-params]:
  <k> pcsContractPart(CN:Id, modifier X:Id {require(C:Expression); _;}) => . ... </k>
  <Contract>
    (.Bag => 
      <Modifier>
        <mname> X </mname>
        <mparameters> .K </mparameters>
        <condition> C </condition>
      </Modifier>)
    ...
  </Contract> 

//Functioncall

rule [function-call]:
  <k> functionCall(F:Id ; Es:Values) => FunQs(FQ,F) ~> Call(F,Es)  ... </k>
  <contractStack> ListItem(CI:Int) ... </contractStack>
  <contractInstance>
    <ctId> CI </ctId>
    <ctname> Cn:Id </ctname>
	  ...
  </contractInstance>
  <contracts>
    <Contract>
      <cname> Cn </cname>
      <cfunction> ... (F |-> CT:Int) ...  </cfunction>
	    ...
    </Contract>
    ...
  </contracts>
  <Function>
    <fId> CT </fId>
    <inputparameters> Ps:FParameters </inputparameters>
    <body> B:Statements </body>
    <FunQuantifiers> FQ </FunQuantifiers>
    <FunCon> Con </FunCon>
    ...
  </Function>
  
rule 
  // as mentioned elsewhere, if(Con){B} isn't enough to handle modifiers
  <k> Call(F:Id,Es:Values) => BindParam(Ps,Es) ~> if(Con){B}  ... </k>
  <contractStack> ListItem(CI:Int) ... </contractStack>
  <contractInstance>
    <ctId> CI </ctId>
    <ctname> Cn:Id </ctname>
    ...
  </contractInstance>
  <contracts>
    <Contract>
      <cname> Cn </cname>
      <cfunction> ... (F |-> CT:Int) ...  </cfunction>
      ...
    </Contract>
    ...
  </contracts>
  <Function>
    <fId> CT </fId>
    <inputparameters> Ps:FParameters </inputparameters>
    <body> B:Statements </body>
    <FunQuantifiers> FQ </FunQuantifiers> // This is not needed, can remove
    <FunCon> Con </FunCon>
    ...
  </Function>
 
    
  // rule <k> functionCall(Sender:Int; C:Int ; F:Id ; Es:Values ; M:Msg) =>  functionCall(C:Int ; F:Id ; Es:Values ; M:Msg)... </k>
  // When a rule only mentions the <k> cell, it can be simplified like this:
  rule functionCall(Sender:Int; C:Int ; F:Id ; Es:Values ; M:Msg) => functionCall(C:Int ; F:Id ; Es:Values ; M:Msg) // Where is the sender gone?!

  rule 
    <k> functionCall(C:Int ; F:Id ; Es:Values ; M:Msg) =>  createTransaction(L) ~> functionCall(F ; Es) ~> returnContext(C) ... </k>
    <contractStack> (.List => ListItem(C)) L:List ListItem(-1) </contractStack>
    <Msg> M1 => M </Msg>
    <MsgStack> (.List => ListItem(M1)) ... </MsgStack>
    <functionStack> (.List => ListItem(F)) ... </functionStack>

  rule 
    <k> createTransaction(.List) => . ... </k> 
    <cnttran> I:Int => I +Int 1 </cnttran>
    <trancomputation> (.Map => I |-> "functioncall" ) ... </trancomputation>  
    <newStack> .List </newStack>

  // Not sure I understand what's going on here. 
  // Does <k> createTransaction(.List) => . ... </k> (above), togethr with the following two rules mean 
  // that we can call a function on another contract but this function cannot in turn call another function?

  rule 
    <k> createTransaction(.List) => . ... </k> 
    <newStack> L </newStack>
      requires L =/=K .List

  rule createTransaction(L) => .
    requires L =/=K .List

  rule 
    <k> returnContext(C:Int) => E ... </k>
    <contractStack> ListItem(C) => .List ... </contractStack>
    <Msg> M => M1 </Msg>
    <MsgStack> ListItem(M1) => .List ... </MsgStack>
    <vposition> _ => 1 </vposition>
    <functionStack> ListItem(F) => .List ... </functionStack>
    <newStack>  L => .List </newStack>
    <contractInstance>
      <ctId> C </ctId>
      <ctname> Cn:Id </ctname>
      ...
    </contractInstance>
    <contracts>
      <Contract>
        <cname> Cn </cname>
        <cfunction> ... (F |-> CT:Int) ...  </cfunction>
        ...
      </Contract>
      ...
    </contracts>
    <Function>
      <fId> CT </fId>
      <Return> E </Return>  
      ...
    </Function>

rule 
  <k> return E:Int; => . ...</k> // What if return value is not an int?
  <functionStack> ListItem(F:Id) ... </functionStack>
  <contractStack> ListItem(CI:Int) ... </contractStack>
  <contractInstance>
    <ctId> CI </ctId>
    <ctname> Cn:Id </ctname>
    ...
  </contractInstance>
  <contracts>
    <Contract>
      <cname> Cn </cname>
      <cfunction> ... (F |-> CT:Int) ...  </cfunction>
      ...
    </Contract>
    ...
  </contracts>
  <Function>  
    <fId> CT </fId>
    <Return> _=> E </Return>
    ...
  </Function> 

rule return; => .

endmodule
