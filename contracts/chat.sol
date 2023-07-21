pragma solidity ^0.8.10;

contract ChatApp {

    struct Message {
        address sender;
        address receiver;
        string content;
        uint timestamp;
        bool read;
    }

    mapping(address => mapping (address => Message[])) private messages;
    mapping(address => address[]) private senders;

    function sendMessage(address _receiver, string memory _content) public {
        require(msg.sender != _receiver, "You cannot send message to yourself");
        messages[msg.sender][_receiver].push(Message(msg.sender, _receiver, _content, block.timestamp, false));

        bool found = false;
        if(senders[_receiver].length == 0) {
            senders[_receiver].push(msg.sender);
        }
        else {
            for(uint i = 0; i < senders[_receiver].length; i++) {
                if (senders[_receiver][i] == msg.sender) {
                    found = true;
                    break;
                }
            }
            if(!found) {
                senders[_receiver].push(msg.sender);
            }
        }

        if(senders[msg.sender].length == 0) {
            senders[msg.sender].push(_receiver);
        }
        else {
            found = false;
            for(uint i = 0; i < senders[msg.sender].length; i++) {
                if (senders[msg.sender][i] == _receiver) {
                    found = true;
                    break;
                }
            }
            if(!found) {
                senders[msg.sender].push(_receiver);
            }
        }
    }

    function getMessages(address _receiver, bool _isSender) public view returns (Message[] memory){
        if (_isSender) {
            return messages[msg.sender][_receiver];
        }
        else {
            return messages[_receiver][msg.sender];
        }
    }

    //get all user that sent message to sender
    function getSenders() public view returns (address[] memory) {
        return senders[msg.sender];
    }

    //mark as read
    function markRead(address _sender, uint _index) public {
        require(_index < messages[_sender][msg.sender].length, "invalid index");
        messages[_sender][msg.sender][_index].read = true;
    }
}