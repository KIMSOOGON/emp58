<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	String boardNo = request.getParameter("boardNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>암호를 입력하시오</h2>
	<form method="post" action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp">
		<div>
			<!-- msg 파라메타값이 있으면 출력 -->
		<%
			  if(request.getParameter("msg") != null){
		%>
				<div class="text-center" style="color:red"><%=request.getParameter("msg")%></div>		
		<%		
			  }
		%>
		</div>
		
		<div>
			<input type="text" name="boardNo" value="<%=boardNo%>">
		</div>
		<div>
			<input type="password" name="boardPw">
		</div>
		<div>
			<button type="submit">확인</button>
		</div>
	</form>
</body>
</html>