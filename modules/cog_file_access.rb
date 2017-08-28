require 'marshall'
require 'cog'
require 'ressurrector_cog'

module CogFileAccess

  # allows one save and exits. Only initial filename allowed.
  # Update gamestate as it changes and save at end.
  def save_cog(game_state: nil, filename: 'savefile')
    Cog.new(
      read_only: %i[saved],
      accessors: %i[game_state],
      args: {
        saved: false,
        game_state: game_state,
        filename: filename,
        logfile: log_cog(filename: filename)
      }) do |save_state|
        return :complete if saved
        begin
          File.open("saves/#{filename}.bin", 'wb') do |f|
            Marshall.dump(save_state[:game_state], f)
          end
          save_state[:saved] = true
        rescue IOError => e
          save_state[:logfile].log_msg = "Saving  Err: #{e.msg}"
        ensure
          save_state[:saved]
        end
      end
  end

  # generates a save_cog based on stored game_state
  def load_into_cog(filename: 'savefile')
    game_state = nil
    File.open("saves/#{filename}.bin", 'rb') do |f|
      game_state = Marshal.load(f)
    end
    save_cog(game_state: game_state, filename: filename)
  end

  # log cog exits on error. Only exits by containing cog exiting.
  # should perform immeditate rotate
  def log_cog(filename: 'logfile')
    logger = RessurrectorCog.new(
      accessors: %i[log_msg severity],
      args: {
        log_msg: %(======= Log Initialised #{Time.now} =======),
        severity: :info,
        filename: filename,
        file: File.open("log/#{filename}.log", 'a+')
      }) do |log_state|
        begin
          log_msg = %Q(=== #{Time.now} #{log_state[:serverity].to_s.upcase} ===
            #{log_state[:log_msg]}
          )
          f.write log_msg && true
        rescue
          :reinit
      end
    logger.turn && logger
  end

  def log_this(log_cog, severity=:info, message)
    log_cog.log_msg = message
    log_cog.severity = severity
    log_cog.turn
  end
end
