// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Ownable {
    address public owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        require(newOwner != owner, "Already owner");

        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

abstract contract ERC20Basic {
    uint256 public totalSupply;

    function balanceOf(address account) external view virtual returns (uint256);
    function transfer(address to, uint256 amount) external virtual returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

abstract contract ERC20 is ERC20Basic {
    function allowance(
        address tokenOwner,
        address spender
    )
        external
        view
        virtual
        returns (uint256);

    function approve(
        address spender,
        uint256 amount
    )
        external
        virtual
        returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    )
        external
        virtual
        returns (bool);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract AURIXNetwork is ERC20, Ownable {
    string public constant name = "AURIX Network";
    string public constant symbol = "AURX";
    uint8 public constant decimals = 18;

    uint256 public constant INITIAL_SUPPLY =
        10000000000 * (10 ** uint256(decimals));

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;
    mapping(address => bool) public lockedAddresses;

    event AddressLocked(address indexed account, bool locked);
    event Burn(address indexed burner, uint256 value);

    constructor() {
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;

        emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
    }

    function balanceOf(
        address account
    )
        external
        view
        override
        returns (uint256)
    {
        return balances[account];
    }

    function allowance(
        address tokenOwner,
        address spender
    )
        external
        view
        override
        returns (uint256)
    {
        return allowed[tokenOwner][spender];
    }

    function transfer(
        address to,
        uint256 amount
    )
        external
        override
        returns (bool)
    {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(
        address spender,
        uint256 amount
    )
        external
        override
        returns (bool)
    {
        require(spender != address(0), "Zero address");

        allowed[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    )
        external
        override
        returns (bool)
    {
        require(
            allowed[from][msg.sender] >= amount,
            "Insufficient allowance"
        );

        allowed[from][msg.sender] -= amount;

        _transfer(from, to, amount);
        return true;
    }

    function increaseApproval(
        address spender,
        uint256 addedValue
    )
        external
        returns (bool)
    {
        require(spender != address(0), "Zero address");

        allowed[msg.sender][spender] += addedValue;

        emit Approval(
            msg.sender,
            spender,
            allowed[msg.sender][spender]
        );

        return true;
    }

    function decreaseApproval(
        address spender,
        uint256 subtractedValue
    )
        external
        returns (bool)
    {
        require(spender != address(0), "Zero address");

        uint256 currentAllowance = allowed[msg.sender][spender];

        if (subtractedValue >= currentAllowance) {
            allowed[msg.sender][spender] = 0;
        } else {
            allowed[msg.sender][spender] =
                currentAllowance -
                subtractedValue;
        }

        emit Approval(
            msg.sender,
            spender,
            allowed[msg.sender][spender]
        );

        return true;
    }

    function lockAddress(
        address account,
        bool locked
    )
        external
        onlyOwner
    {
        require(account != address(0), "Zero address");
        require(account != owner, "Cannot lock owner");

        lockedAddresses[account] = locked;

        emit AddressLocked(account, locked);
    }

    function burn(
        uint256 amount
    )
        external
        onlyOwner
    {
        require(amount > 0, "Amount is zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        totalSupply -= amount;

        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    )
        internal
    {
        require(to != address(0), "Zero address");
        require(!lockedAddresses[from], "Sender locked");
        require(balances[from] >= amount, "Insufficient balance");

        balances[from] -= amount;
        balances[to] += amount;

        emit Transfer(from, to, amount);
    }
}
