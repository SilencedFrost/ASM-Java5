package com.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OutboundCommentDTO implements CommentDTO{
    private Long commentId;
    private Long userId;
    private Long productId;
    private LocalDateTime commentDate;
    private String commentContent;
}