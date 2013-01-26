class InvertPieceComposerAssociation < ActiveRecord::Migration
  def up
    add_column :composers, :piece_id, :integer
    add_index :composers, :piece_id

    # Copy foreign key from piece to composer records
    Piece.all.each do |piece|
      composer = Composer.find(piece.composer_id)
      composer.piece_id = piece.id
      composer.save
    end

    remove_column :pieces, :composer_id
  end

  def down
    add_column :pieces, :composer_id, :integer

    # Copy foreign key from composer to piece records
    Composer.all.each do |composer|
      piece = Piece.find(composer.piece_id)
      piece.composer_id = composer.id
      piece.save
    end

    remove_index :composers, :piece_id
    remove_column :composers, :piece_id
  end
end
