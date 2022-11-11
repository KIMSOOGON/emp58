<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	
	// 2. 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("1) updateCommentForm 드라이버로딩완료"); // 디버깅
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://localhost:3306/employees","root","java1234");
	System.out.println("2) updateCommentForm Connection 완료 :"+conn); // 디버깅
	
	// 쿼리 문자열 작성
	String sql = "SELECT comment_pw commentPw, comment_content commentContent, createdate FROM comment WHERE comment_no = ? AND board_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println("3) updateCommentForm stmt :"+stmt); // 디버깅
	
	stmt.setInt(1,commentNo);
	stmt.setInt(2,boardNo);
	ResultSet rs = stmt.executeQuery();
	
	Comment c = new Comment();
	c.commentNo = commentNo;
	c.boardNo = boardNo;
	c.commentPw = null;
	c.commentContent = null;
	
	if(rs.next()){
		c.commentPw = rs.getString("commentPw");
		c.commentContent = rs.getString("commentContent");
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updateCommentForm</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body style="background-color:rgb(200,200,205)">
	<form method="post" action="<%=request.getContextPath()%>/board/updateCommentAction.jsp">
		<div class="container mt-4 p-4 bg-light text-center">
			<h2 class="container mt-3 p-3 bg-dark text-warning">댓글 수정하시렵니까?</h2>
			<table class="table talbe-hover">
				<tr>
					<td colspan="2"><input type="hidden" name="boardNo" value="<%=c.boardNo%>"></td>
				</tr>
				<tr>
					<td>Comment Number</td>
					<td><input type="text" name="commentNo" value="<%=c.commentNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>내용</td>
					<td>
						<textarea rows="5" cols="60" name="commentContent"><%=c.commentContent%></textarea>
					</td>
				</tr>
				<!-- 입력에 오류 발생 시 -->
				<%	// 내용 공백으로 입력할 경우 출력
					if(request.getParameter("contentMsg")!=null){
				%>
						<tr>
							<td class="text-danger" colspan="2"><%=request.getParameter("contentMsg")%></td>
						</tr>
				<%
					}
					// 내용 공백으로 입력할 경우 출력
					if(request.getParameter("pwMsgMsg")!=null){
				%>
						<tr>
							<td class="text-danger" colspan="2"><%=request.getParameter("pwMsg")%></td>
						</tr>
				<%
					}
					// 내용 공백으로 입력할 경우 출력
					if(request.getParameter("failMsg")!=null){
				%>
						<tr>
							<td class="text-danger" colspan="2"><%=request.getParameter("failMsg")%></td>
						</tr>
				<%
					}
				%>
				<tr>
					<td>패스워드</td>
					<td><input type="password" name="commentPw"></td>
				</tr>
				<tr>
					<td colspan="2">
						<button class="btn btn-warning text-center" type="submit">YES</button>
					</td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>