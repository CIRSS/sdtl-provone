### Outline of a Geist progam for generating ProvONE triples from SDTH triples

1. Assign the type `provone:Program` to each `sdth:Program` and `sdth:ProgramStep`. 
(There is no need to create new identifiers because subjects/objects can have any number of types.)
And add a triple using the `provone:hasSubProgram` predicate relating each ProgramStep to its containing
sdth:Program.

2. For each program step that produces or consumes dataframes create new identifiers for output and input ports respectively, assign to them a new type derived from `provone:Port`, `DataframePort`,  to distinguish them from ports representing the flow of variables (`sdth:VariablePort`, see 3 below), and construct a new triple for each port with the `provone:hasInPort` or `provone:hasOutPort` predicate. 

3. For each step construct new `sdth:VariablePort` identifiers similarly for each variable in an input or output dataframe that is used or assigned respectively.

4. Create identifiers for each matching input-output port pair, with type `sdth:DataframeChannel` for channels that carry dataframes and type `sdth:VariableChannel` for channels that carry variables, where both types of channels are derived from `provone:Channel`. Assign the property `provone:connectsTo` to input and output ports to associate them with channels.

5. Assign properties `sdth:hasDataframe` or `sdth:hasVariable` to each port and channel to maintain connection to the corresponding SDTH entities.

6. Declare the subclass relationships between `provone:Port` and both `sdth:DataframePort` and `sdth:VariablePort`; and between `provone:Channel` and both `sdth:DataframeChannel` and `sdth:VariableChannel`.


