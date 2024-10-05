use zen_class_programme;

-- // Create collections
db.createCollection("users");
db.createCollection("codekata");
db.createCollection("attendance");
db.createCollection("topics");
db.createCollection("tasks");
db.createCollection("company_drives");
db.createCollection("mentors");

-- // Insert sample users
db.users.insertMany([
    { _id: 1, name: "John Doe", email: "john@example.com", phone: "1234567890" },
    { _id: 2, name: "Jane Smith", email: "jane@example.com", phone: "9876543210" },
    { _id: 3, name: "Alice Johnson", email: "alice@example.com", phone: "1112223333" },
    { _id: 4, name: "Bob Brown", email: "bob@example.com", phone: "4445556666" },
]);

-- // Insert sample topics data for October
db.topics.insertMany([
    { topic_name: "JavaScript Basics", date: new Date("2023-10-05") },
    { topic_name: "MongoDB Basics", date: new Date("2023-10-15") },
    { topic_name: "React Basics", date: new Date("2023-10-25") },
]);

-- // Insert sample tasks data related to topics
db.tasks.insertMany([
    { task_name: "JavaScript Assignment", topic_name: "JavaScript Basics", deadline: new Date("2023-10-10"), status: "not_submitted", user_id: 1 },
    { task_name: "MongoDB Project", topic_name: "MongoDB Basics", deadline: new Date("2023-10-20"), status: "submitted", user_id: 2 },
    { task_name: "React Task", topic_name: "React Basics", deadline: new Date("2023-10-30"), status: "not_submitted", user_id: 1 },
]);

-- // Insert sample codekata data
db.codekata.insertMany([
    { user_id: 1, problems_solved: 15 },
    { user_id: 2, problems_solved: 20 },
    { user_id: 3, problems_solved: 25 },
]);

-- // Insert sample attendance data
db.attendance.insertMany([
    { user_id: 1, date: new Date("2020-10-01"), status: "present" },
    { user_id: 1, date: new Date("2020-10-02"), status: "absent" },
    { user_id: 2, date: new Date("2020-10-03"), status: "present" },
    { user_id: 3, date: new Date("2020-10-16"), status: "absent" },
]);

-- // Insert sample company drives data
db.company_drives.insertMany([
    { company_name: "Tech Company A", date: new Date("2020-10-16"), students_appeared: [1, 2] },
    { company_name: "Tech Company B", date: new Date("2020-10-20"), students_appeared: [1] },
]);

-- // Insert sample mentors data
db.mentors.insertMany([
    { mentor_name: "Mentor A", mentees: [1, 2, 3] },
    { mentor_name: "Mentor B", mentees: [4] },
]);


-- // Find topics in October
 db.topics.find({
    date: {
        $gte: new Date("2023-10-01"),
        $lt: new Date("2023-11-01")
    }
}).toArray();

-- // Find tasks in October
 db.tasks.find({
    deadline: {
        $gte: new Date("2023-10-01"),
        $lt: new Date("2023-11-01")
    }
}).toArray();



-- company drives which appeared between 15 Oct 2020 and 31 Oct 2020
 db.company_drives.find({
    date: {
        $gte: new Date("2020-10-15"),
        $lte: new Date("2020-10-31")
    }
}).toArray();

print("Company Drives from 15 Oct 2020 to 31 Oct 2020:", JSON.stringify(companyDrives));


--  company drives and students who appeared for the placement
 db.company_drives.aggregate([
    {
        $lookup: {
            from: "users",
            localField: "students_appeared",
            foreignField: "_id",
            as: "students_info"
        }
    }
]).toArray();


--  number of problems solved by the user in CodeKata

 db.codekata.aggregate([
    {
        $lookup: {
            from: "users",
            localField: "user_id",
            foreignField: "_id",
            as: "user_info"
        }
    },
    {
        $project: {
            user: { $arrayElemAt: ["$user_info.name", 0] },
            problems_solved: 1
        }
    }
]).toArray();


-- the mentors who have mentee counts greater than 15
 db.mentors.find({
    $expr: { $gt: [{ $size: "$mentees" }, 15] }
}).toArray();



-- the number of users who are absent and tasks are not submitted between 15 Oct 2020 and 31 Oct 2020

db.attendance.aggregate([
    {
        $match: {
            date: {
                $gte: new Date("2020-10-15"),
                $lte: new Date("2020-10-31")
            },
            status: "absent"
        }
    },
    {
        $lookup: {
            from: "tasks",
            localField: "user_id",
            foreignField: "user_id",
            as: "task_info"
        }
    },
    {
        $match: {
            "task_info.status": "not_submitted"
        }
    },
    { $count: "absent_and_not_submitted_users" }
]).toArray();




