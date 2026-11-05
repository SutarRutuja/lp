// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StudentData {
    struct Student {
        uint256 rollNo;
        string name;
        string course;
        uint256 marks;
    }

    Student[] private students;

    mapping(uint256 => bool) private rollNoExists;

    event StudentAdded(uint256 indexed rollNo, string name);

    function addStudent(
        uint256 _rollNo,
        string calldata _name,
        string calldata _course,
        uint256 _marks
    ) external {
        require(!rollNoExists[_rollNo], "Roll number already exists");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_course).length > 0, "Course cannot be empty");
        require(_marks <= 100, "Marks must be between 0 and 100");

        students.push(Student(_rollNo, _name, _course, _marks));
        rollNoExists[_rollNo] = true;

        emit StudentAdded(_rollNo, _name);
    }

    function getStudent(uint256 _index)
        external
        view
        returns (uint256 rollNo, string memory name, string memory course, uint256 marks)
    {
        require(_index < students.length, "Invalid student index");

        Student storage student = students[_index];
        return (student.rollNo, student.name, student.course, student.marks);
    }

    function getAllStudents() external view returns (Student[] memory) {
        return students;
    }

    function getStudentCount() external view returns (uint256) {
        return students.length;
    }
}
