class PostsController < ApplicationController

    def new

    end

    def create

    end

    def show

    end

    def edit

    end

    def update

    end

    private

    def post_params
        params.require(:post).permit(:title, :url, :content)
    end
end
