
import {NaffleTypes} from "../../../../contracts/libraries/NaffleTypes.sol";

interface IL1NaffleBase {
    function createNaffle(
        address _ethTokenAddress, 
        address _owner,
        uint256 _nftId, 
        uint256 _paidTicketSpots,
        uint256 _ticketPriceInWei,
        uint256 _endTime, 
        NaffleTypes.NaffleType _naffleType
    ) external returns (uint256 naffleId, bytes32 txHash);

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4);

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) external pure returns (bytes4);

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) external pure returns (bytes4);

    function getMinimumNaffleDuration() external view returns (uint256);
    function getMinimumPaidTicketSpots() external view returns (uint256);
    function getZkSyncNaffleContractAddress() external view returns (address);
    function getZkSyncAddress() external view returns (address);
    function getFoundersKeyAddress() external view returns (address);
    function getFoundersKeyPlaceholderAddress() external view returns (address);

    function setMinimumNaffleDuration(uint256 _minimumNaffleDuration) external;
    function setMinimumPaidTicketSpots(uint256 _minimumPaidTicketSpots) external;
    function setZkSyncNaffleContractAddress(address _zkSyncNaffleContractAddress) external;
    function setZkSyncAddress(address _zkSyncAddress) external;
    function setFoundersKeyAddress(address _foundersKeyAddress) external;
    function setFoundersKeyPlaceholderAddress(address _foundersKeyPlaceholderAddress) external;
}
