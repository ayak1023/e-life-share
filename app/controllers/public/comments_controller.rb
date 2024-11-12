class Public::CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params.merge(user_id: current_user.id))
    if @comment.save
    else
      render 'public/posts/show', alert {"コメント送信に失敗しました。"}
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
