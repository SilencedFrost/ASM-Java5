package com.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class InboundCommentDTO implements CommentDTO{
    private Long userId;
    private Long productId;
    private String commentContent;
}
