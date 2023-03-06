"""Create users table

Revision ID: e09be4ddb7ae
Revises: 23929587e120
Create Date: 2023-02-28 22:40:27.576729

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'e09be4ddb7ae'
down_revision = '23929587e120'
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        'users',
        sa.Column('id', sa.UUID, primary_key=True),
        sa.Column('email', sa.String(200), nullable=False, unique=True),
        sa.Column('password', sa.String(200), nullable=False),
    )


def downgrade() -> None:
    op.drop_table('users')
