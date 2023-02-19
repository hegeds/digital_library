"""create book and author

Revision ID: 23929587e120
Revises:
Create Date: 2023-02-05 23:55:15.161732

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '23929587e120'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        'books',
        sa.Column('id', sa.UUID, primary_key=True),
        sa.Column('isbn', sa.String(13), nullable=False),
        sa.Column('title', sa.String(200), nullable=False),
        sa.Column('published', sa.Integer, nullable=False),
    )
    op.create_table(
        'authors',
        sa.Column('id', sa.UUID, primary_key=True),
        sa.Column('name', sa.String(200), nullable=False),
    )
    op.create_table(
        'books_authors_relationships',
        sa.Column(
            'author_id', sa.UUID, sa.ForeignKey("authors.id"), nullable=False
        ),
        sa.Column(
            'book_id', sa.UUID, sa.ForeignKey("books.id"), nullable=False
        ),
    )


def downgrade() -> None:
    op.drop_table('books_authors_relationships')
    op.drop_table('authors')
    op.drop_table('books')
