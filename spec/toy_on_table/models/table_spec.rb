# frozen_string_literal: true

require_relative '../../../lib/toy_on_table/models/table_cell'
require_relative '../../../lib/toy_on_table/models/table'

describe ToyOnTable::Models::Table do
  describe '.initialize' do
    it 'sets row_count and column_count' do
      table = ToyOnTable::Models::Table.new(7, 8)

      expect(table.row_count).to eq 7
      expect(table.column_count).to eq 8
    end
  end

  describe '#include?' do
    let(:table) { ToyOnTable::Models::Table.new(4, 8) }

    it 'returns true if the given cell is inside the table' do
      table_cell = ToyOnTable::Models::TableCell.new(3, 7)

      expect(table.include?(table_cell)).to be_truthy
    end

    context 'outside table' do
      it 'returns false if the row of given cell is outside the table' do
        table_cell = ToyOnTable::Models::TableCell.new(4, 7)

        expect(table.include?(table_cell)).to be_falsey
      end

      it 'returns false if the column of given cell is outside the table' do
        table_cell = ToyOnTable::Models::TableCell.new(3, 8)

        expect(table.include?(table_cell)).to be_falsey
      end

      it 'returns false if the column of given cell is outside the table' do
        table_cell = ToyOnTable::Models::TableCell.new(-3, -8)

        expect(table.include?(table_cell)).to be_falsey
      end
    end
  end
end
