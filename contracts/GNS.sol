import "./GNSlib.sol";

pragma solidity ^0.4.24;

contract GNS is GNSlib {

    /*  STORAGE
    */

    mapping(string => address) private _owners;
    mapping(string => bytes[]) private _records;
    mapping(string => mapping(bytes => uint128)) private _indexesOfRecords;

    /*  MODIFIERS
    */

    /** @notice Verifies is sender address is owner of record name
    */
    modifier onlyOwnerOfName(string _name) {
        require(_owners[_name] == 0 || _owners[_name] == msg.sender);
        _;
    }

    /** @notice Verifies is record name exists
    */
    modifier onlyExistName(string _name) {
        require(_owners[_name] != 0);
        _;
    }

    /*  PUBLIC
    */

    /** @notice Returns owner of record name
    */
    function getOwnerOfName(string _name) view public returns (address) {
        return _owners[_name];
    }

    /** @notice Adds new record to register
    */
    function createRecord(
        string _name,
        bytes _rawRecord)
    onlyOwnerOfName(_name)
    public
    {
        //        require(isValidRecord(_rawRecord)); // fixme disabled validity check

        if (_indexesOfRecords[_name][_rawRecord] > 0) {
            revert();
        }
        if(!isNameExist(_name)){
            _owners[_name] = msg.sender;
        }
        if (_records[_name].length == 0){
            _records[_name].length++;
        }
        _indexesOfRecords[_name][_rawRecord] = uint128(_records[_name].push(_rawRecord) - 1);
    }

    /** @notice Removes record based on data
    */
    function removeRecord(
        string _name,
        bytes _rawRecord)
    onlyExistName(_name)
    onlyOwnerOfName(_name)
    public
    {
        uint128 recordIndex = _indexesOfRecords[_name][_rawRecord];
        bytes[] storage recordsForName = _records[_name];
        if (recordIndex == 0)
            revert();
        if (recordsForName.length - 1 == recordIndex) {
            recordsForName.length--;
            delete _indexesOfRecords[_name][_rawRecord];
        } else {
            recordsForName[recordIndex] = recordsForName[recordsForName.length-1];
            recordsForName.length--;
            _indexesOfRecords[_name][recordsForName[recordIndex]] = recordIndex;
            delete _indexesOfRecords[_name][_rawRecord];
        }
    }

    /** @notice Returns record based on ID
    *   index in range from 1 to getRecordsCount
    */
    function getRawRecordAt(
        string _name,
        uint128 _index
    )
    view
    public
    returns (bytes)
    {
        require(_index > 0 && _index < _records[_name].length);
        return _records[_name][_index];
    }

    /** @notice Get records count for name
    */
    function getRecordsCount(
        string _name
    )
    view
    public
    returns (uint128)
    {
        uint128 count = uint128(_records[_name].length);
        if(count == 0)
            return 0;
        return count - 1;
    }

    /** @notice Checks whether name in register exists
    */
    function isNameExist(
        string _name)
    view
    public
    returns (bool)
    {
        return _owners[_name] != 0;
    }
}
