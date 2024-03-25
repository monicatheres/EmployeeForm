<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.*, org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Details Upload</title>
</head>
<body>

<%
    String url = "jdbc:mysql://localhost:3306/office";
    String username = "root";
    String password = "admin";

    Connection conn = null;
    PreparedStatement pstmt = null;
    InputStream fileContent = null;

    boolean isMultipart = ServletFileUpload.isMultipartContent(request);

    if (isMultipart) {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);

        try {
            List<FileItem> items = upload.parseRequest(request);
            String empfirstname = "";
            String emplastname="";
            String empmail="";
            String empcontact = "";
            String empcity="";
            String empstates="";
            String empcountry="";
            String empmessage="";
            String resume="";
           

            for (FileItem item : items) {
                if (item.isFormField()) {
                    if (item.getFieldName().equals("empfirstname")) {
                        empfirstname = item.getString();
                    } else if (item.getFieldName().equals("emplastname")) {
                        emplastname = item.getString();
                    } else if (item.getFieldName().equals("empmail")) {
                        empmail = item.getString();
                    } else if (item.getFieldName().equals("empcontact")) {
                        empcontact = item.getString();
                    } else if (item.getFieldName().equals("empcity")) {
                        empcity = item.getString();
                    } else if (item.getFieldName().equals("empstates")) {
                        empstates = item.getString();
                    } else if (item.getFieldName().equals("empcountry")) {
                        empcountry = item.getString();
                    } else if (item.getFieldName().equals("empmessage")) {
                        empmessage = item.getString();
                    }
                } else {
                    resume = item.getName();
                    fileContent = item.getInputStream();
                }
            }

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);

            String sql = "INSERT INTO employee (empfirstname, emplastname, empemail, empcontact, empcity, empstates,"
            +" empcountry, empmessage, resume) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, empfirstname);
            pstmt.setString(2, emplastname);
            pstmt.setString(3, empmail);
            pstmt.setString(4, empcontact);
            pstmt.setString(5, empcity);
            pstmt.setString(6, empstates);
            pstmt.setString(7, empcountry);
            pstmt.setString(8, empmessage);
            pstmt.setBinaryStream(9, fileContent);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("Employee details uploaded successfully!");
            } else {
                out.println("Error: Failed to upload employee details.");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
            e.printStackTrace(); // Log the exception for debugging
        } finally {
            // Close resources in a finally block to ensure they are always closed
            if (fileContent != null) {
                fileContent.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }
%>

</body>
</html>
