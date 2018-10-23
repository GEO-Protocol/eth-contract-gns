pragma solidity ^0.4.24;

contract GNSlib {

    constructor() public {

    }

    function stringToHexHelper(string what) pure public returns (bytes) {
        return bytes(what);
    }

    /** @notice Verifies name validness. Name should not contain dots (".")
    */
    function isValidName(string _name) pure public returns (bool) {
        bytes memory nameInByteArray = bytes(_name);
        for (uint128 i = 0; i < nameInByteArray.length; i++)
            if (nameInByteArray[i] == '.')
                return false;
        return true;
    }

    /** @notice Verifies validness of part of record
    */
    function isValidString(bytes _str, uint32 _offset, uint32 _length) pure public returns (bool) {
        if (_str.length < _offset + _length)
            return false;
        for (uint128 i = _offset; i < _length; i++)
            if (_str[i] == 0)
                return false;
        return true;
    }

    /** @notice Verifies is record name exists
    */
    function bytesToUint32LE(bytes _what, uint32 _offset) pure public returns (uint32) {
        require(_what.length >= _offset + 4);
        return uint32(_what[_offset + 3])
        | (uint32(_what[_offset + 2]) << 8)
        | (uint32(_what[_offset + 1]) << 16)
        | (uint32(_what[_offset + 0]) << 24);
    }

    /**
     * If type of protocol not in range for custom or not unknown type, the function returns false
     */
    function isValidRecord(bytes _rawRecord) pure public returns (bool) {
        if (_rawRecord.length <= 1)
            return false;
        uint8 typeOfRecord = uint8(_rawRecord[0]);
        if (typeOfRecord >= 64 && typeOfRecord <= 255)
            return true;
        if (typeOfRecord == 0) //fixme you can't check every type of record onchain, so there is no need to do that
            return isValidFDNSRecord(_rawRecord);
        else if (typeOfRecord == 1)
            return isValidIPv4Record(_rawRecord);
        else if (typeOfRecord == 2)
            return isValidIPv6Record(_rawRecord);
        else if (typeOfRecord == 3)
            return isValidDNSRecord(_rawRecord);
        return false;
    }

    function isValidFDNSRecord(bytes _rawRecord) pure public returns (bool) {
        uint8 typeOfRecord = uint8(_rawRecord[0]);
        if (typeOfRecord != 0)
            return false;
        if (_rawRecord.length < 5)
            return false;
        if (uint32(_rawRecord.length - 5) != bytesToUint32LE(_rawRecord, 1))
            return false;
        return true;
    }

    function isValidIPv4Record(bytes _rawRecord) pure public returns (bool) {
        uint8 typeOfRecord = uint8(_rawRecord[0]);
        if (typeOfRecord != 1)
            return false;
        if (_rawRecord.length != 5)
            return false;
        return true;
    }

    function isValidIPv6Record(bytes _rawRecord) pure public returns (bool) {
        uint8 typeOfRecord = uint8(_rawRecord[0]);
        if (typeOfRecord != 2)
            return false;
        if (_rawRecord.length != 17)
            return false;
        return true;
    }

    function isValidDNSRecord(bytes _rawRecord) pure public returns (bool) {
        uint8 typeOfRecord = uint8(_rawRecord[0]);
        if (typeOfRecord != 3)
            return false;
        if (!isValidString(_rawRecord, 1, uint32(_rawRecord.length - 1)))
            return false;
        return true;
    }
}
