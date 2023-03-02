from slither.core.declarations.contract import Contract
from slither.core.declarations.enum_contract import EnumContract
from slither.core.declarations.structure_contract import StructureContract
from slither.core.solidity_types.array_type import ArrayType
from slither.core.solidity_types.elementary_type import ElementaryType
from slither.core.solidity_types.mapping_type import MappingType
from slither.core.solidity_types.user_defined_type import UserDefinedType
from slither.printers.abstract_printer import AbstractPrinter


class STRUCTS(AbstractPrinter):

    ARGUMENT = "structs"
    HELP = "Export the ERD of the Structs"

    WIKI = "https://github.com/trailofbits/slither/wiki/Printer-documentation#NA"

    def __getElemType(self, elemType):
        res = ""
        if isinstance(elemType, MappingType):
            res = f"{elemType}"
        elif isinstance(elemType, ArrayType):
            res = f"{elemType}"
        elif isinstance(elemType, ElementaryType):
            res = elemType.type
        elif isinstance(elemType, UserDefinedType) and isinstance(elemType.type, Contract):
            res = f"{elemType.type.name}(address)"
        elif isinstance(elemType, UserDefinedType) and isinstance(elemType.type, EnumContract):
            res = elemType.type.canonical_name
        elif isinstance(elemType, UserDefinedType) and isinstance(elemType.type, StructureContract):
            res = elemType.type.canonical_name
        else:
            raise Exception(f"Unknown type {elemType}")
        
        return res

    def output(self, filename):
        """
        current file being analyzed
        Args:
            filename(string)
        """

        all_files = []
        
        contracts = [contract for contract in self.contracts if not contract.is_top_level]
        connections = []
        erdString = f"@startuml {filename}\n\n"
        
        
        for contract in contracts:
            pkgString = f"package {contract.name} {{\n\n"
            
            
            # Handle enums
            for e in contract.enums:
                enumString = f"    enum {e.canonical_name} {{\n"
                for elem in e.values:
                    enumString = enumString + f"        {elem}\n"
                enumString = enumString + "    }\n\n"
                pkgString = pkgString + enumString
            
            # Handle structs
            for struct in contract.structures:
                structString = f"    struct {struct.canonical_name} {{\n"
                
                for elem in struct.elems_ordered:

                    # Handle types
                    elemType = self.__getElemType(elem.type)

                    # Handle connections
                    if isinstance(elem.type, UserDefinedType) and not isinstance(elem.type.type, Contract):
                        connections.append(f"{struct.canonical_name}::{elem.name} --> {elemType}")
                    elif isinstance(elem.type, ArrayType) and isinstance(elem.type.type, UserDefinedType) and isinstance(elem.type.type.type, StructureContract):
                        connections.append(f"{struct.canonical_name}::{elem.name} --> {self.__getElemType(elem.type.type)}")
                    elif isinstance(elem.type, MappingType):
                        if isinstance(elem.type.type_from, UserDefinedType) and not isinstance(elem.type.type_from.type, Contract):
                            connections.append(f"{struct.canonical_name}::{elem.name} --> {self.__getElemType(elem.type.type_from)}")
                        if isinstance(elem.type.type_to, UserDefinedType) and not isinstance(elem.type.type_to.type, Contract):
                            connections.append(f"{struct.canonical_name}::{elem.name} --> {self.__getElemType(elem.type.type_to)}")

                    structString = structString + f"        {elemType} {elem.name}\n"
                
                structString = structString + "    }\n\n"
                pkgString = pkgString + structString
                


            pkgString = pkgString + "}\n\n"
            erdString = erdString + pkgString


        erdString = erdString + "\n".join(list(set(connections))) + "\n\n@enduml"
        
        if filename:
            new_filename = f"{filename}-ERD.puml"
        else:
            new_filename = f"ERD.puml"

        with open(new_filename, "w", encoding="utf8") as f:
            f.write(erdString)
        all_files.append((new_filename, erdString))
        
        info = f"Export ERD to {new_filename}\n"
        self.info(info)
        res = self.generate_output(info)
        return res
